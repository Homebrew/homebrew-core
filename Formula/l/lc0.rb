class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.32.1",
      revision: "fd71a2d921b689c5f479d3227c3806c8e272d9c5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75551935a94b7a1148803a65e879cd7df224f26742aea24e9a8644b29452010e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a1d1d13de8396fbf2c8b91fedb5e6e880f43c8b7a4a195351f78904da1dd6f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8f7930982cfc4dd3b8f4e90166787a7b12be3bec318ef5527757de2d572bcf9"
    sha256 cellar: :any,                 arm64_linux:       "8eb6f6694688e38cbfa126ab9e55dc918a9e0c9dd6938f41669c7a50655f8ff1"
    sha256 cellar: :any,                 x86_64_linux:      "23eb4f71a6ff74cf4bfb7e3c2b080e392ec900d2a0b5053fc3af1a7966d0588b"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"

  uses_from_macos "python" => :build # required to compile .pb files

  on_linux do
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

  # We use "753723" network with 15 blocks x 192 filters (from release notes)
  # Downloaded from https://training.lczero.org/networks/?show_all=0
  resource "network" do
    url "https://storage.lczero.org/files/networks/3e3444370b9fe413244fdc79671a490e19b93d3cca1669710ffeac890493d198", using: :nounzip
    sha256 "ca9a751e614cc753cb38aee247972558cf4dc9d82c5d9e13f2f1f464e350ec23"
  end

  def install
    ENV.append_to_cflags "-I#{formula_opt_include("eigen")}/eigen3"

    args = ["-Dgtest=false", "-Dbindir=libexec"]

    if OS.mac?
      # Disable metal backend for older macOS
      # Ref https://github.com/LeelaChessZero/lc0/issues/1814
      args << "-Dmetal=disabled" if MacOS.version <= :big_sur
    else
      args << "-Dopenblas_include=#{formula_opt_include("openblas")}"
      args << "-Dopenblas_libdirs=#{formula_opt_lib("openblas")}"
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    bin.write_exec_script libexec/"lc0"
    resource("network").stage { libexec.install Dir["*"].first => "42850.pb.gz" }
  end

  test do
    assert_match "BLAS vendor:",
      shell_output("#{bin}/lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Using Eigen",
      shell_output("#{bin}/lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end
