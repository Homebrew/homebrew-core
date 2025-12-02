class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.32.1",
      revision: "fd71a2d921b689c5f479d3227c3806c8e272d9c5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80eac538cad677c06ca03410d3499a47885d90a9d77d65faf5578a8fd8c1eb51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f980cd903c469545962a5f05121057f093088711e842d62e3c0fa11dfc8216de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3050bbdbb6ee889347dd645657a9e7b7d3b8d5a97ce5a67f07b972bfe52eb43c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e00ec4151f69e3b3766425f45885084e72938bb479f79412aa7216bb3f19d18"
    sha256                               arm64_linux:   "55a6ad7109bfe95e15153f49943ff9d71aacc1d36007acb991a09e564ef87eb7"
    sha256                               x86_64_linux:  "e6d32af046f1abc89dd50835f1cb93d2515b0ddb278e48f4bf0d2c19d831b14a"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"

  uses_from_macos "python" => :build # required to compile .pb files
  uses_from_macos "zlib"

  on_linux do
    depends_on "openblas"
  end

  # We use "753723" network with 15 blocks x 192 filters (from release notes)
  # Downloaded from https://training.lczero.org/networks/?show_all=0
  resource "network" do
    url "https://training.lczero.org/get_network?sha=3e3444370b9fe413244fdc79671a490e19b93d3cca1669710ffeac890493d198", using: :nounzip
    sha256 "ca9a751e614cc753cb38aee247972558cf4dc9d82c5d9e13f2f1f464e350ec23"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["eigen"].opt_include}/eigen3"

    args = ["-Dgtest=false", "-Dbindir=libexec"]

    if OS.mac?
      # Disable metal backend for older macOS
      # Ref https://github.com/LeelaChessZero/lc0/issues/1814
      args << "-Dmetal=disabled" if MacOS.version <= :big_sur
    else
      args << "-Dopenblas_include=#{Formula["openblas"].opt_include}"
      args << "-Dopenblas_libdirs=#{Formula["openblas"].opt_lib}"
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
