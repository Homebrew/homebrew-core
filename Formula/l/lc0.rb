class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.32.1",
      revision: "fd71a2d921b689c5f479d3227c3806c8e272d9c5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9af0c3404413f7d61bdabebed5b36f18cd46d38d67435add1737ea07c0c09849"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d26534ed3db2d70eeb6b02f404defdfa04bc3a402437d2fc334bdac71baff11e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4210f76c40249e7e81c682f80edb881bbba6e6e9508d484e4fb4649ac45b42df"
    sha256 cellar: :any_skip_relocation, tahoe:         "0864f484b7eec673ec082e6979c258db9e33243def5d23b9d003ff3d7877a42c"
    sha256 cellar: :any_skip_relocation, sonoma:        "685a0fcf141311b503520396025e4296f9f3656582d030e854667ac07d5d4bd4"
    sha256                               arm64_linux:   "01f90bf4ae497e1a3c8de9db65a7a85f3d3366e056eff269d2f6b0497fcda731"
    sha256                               x86_64_linux:  "a37761e31c707318e6c92cb6b7c11567e3e1e925146270f86ec344fa0b038419"
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
