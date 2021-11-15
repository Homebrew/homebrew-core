class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.28.0",
      revision: "3982cc0e74b576476c875da6fa0ff81164287425"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392f9168c6f244ddff5ae49eeaa336fa96c4c76e29f6cfa8932c40defca12889"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36aa6aad76aee88ce231dc5a0aac948f097055351813351876acd08dfc450a03"
    sha256 cellar: :any_skip_relocation, monterey:       "d109979fed723569ff979e1cc24db86f1df7c5c8bf8b8bfcf9be6eb971441e28"
    sha256 cellar: :any_skip_relocation, big_sur:        "994f3b0045579eccda6c5eb1241a4484c202bb9c8528184ba2e4eee770a7e2c5"
    sha256 cellar: :any_skip_relocation, catalina:       "e37cf24d564b5649d873692e5162a90e7e1840e2346326be86ef0ba25c8b7737"
    sha256 cellar: :any_skip_relocation, mojave:         "650ff1cdf5e4aad508572322e89010722c92bf30b89ed07f95cdec6dd1fd0140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d89547675b9eb3c62073100047d9f9d91e51f9d3063655cf38e7f836dd28063"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build # required to compile .pb files
  depends_on "eigen"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
    depends_on "openblas"
  end

  fails_with gcc: "5"

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
