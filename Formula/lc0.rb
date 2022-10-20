class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.28.2",
      revision: "fa5864bb5838e131d832ad63300517f4684913e7"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f70c06601952298038fac27e1f00c6845a7e336cca8da9076dafe8b837d7564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18f719db679ef2edec0db9c9be8c6ac45ebd7fbfefb2e4adfe522a3c298d8a92"
    sha256 cellar: :any_skip_relocation, monterey:       "be1f92357b0668c1d42750b4c7bfd36d1edd9e17e2a8df0e4042dab94b080f33"
    sha256 cellar: :any_skip_relocation, big_sur:        "855b625c35f7d2a2ac011fd23f1aa221cf0850e648ffb356435e018da9f9b5fa"
    sha256 cellar: :any_skip_relocation, catalina:       "e4191dceb99061e6e995db5d328214ee19eaf7e832ad6a2f5403d0007f397989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5da943accf3dc382dd468452549610d482c7f15ab49d68e22c950a8a8dc82a"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build # required to compile .pb files
  depends_on "eigen"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openblas"
  end

  fails_with gcc: "5" # for C++17

  resource "network" do
    url "https://training.lczero.org/get_network?sha=00af53b081e80147172e6f281c01daf5ca19ada173321438914c730370aa4267", using: :nounzip
    sha256 "12df03a12919e6392f3efbe6f461fc0ff5451b4105f755503da151adc7ab6d67"
  end

  def install
    args = ["-Dgtest=false"]
    if OS.linux?
      args << "-Dopenblas_include=#{Formula["openblas"].opt_include}"
      args << "-Dopenblas_libdirs=#{Formula["openblas"].opt_lib}"
    end
    system "meson", *std_meson_args, *args, "build/release"

    cd "build/release" do
      system "ninja", "-v"
      libexec.install "lc0"
    end

    bin.write_exec_script libexec/"lc0"
    resource("network").stage { libexec.install Dir["*"].first => "42850.pb.gz" }
  end

  test do
    assert_match "Creating backend [blas]",
      shell_output("lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Creating backend [eigen]",
      shell_output("lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end
