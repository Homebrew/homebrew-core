class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/refs/tags/1.2.5.tar.gz"
  sha256 "fd8f3695484c88f45eac83b7c866e5826e894e102b0d4974be08cb47e18d2ab9"
  license "MIT"
  head "https://github.com/nanomsg/nanomsg.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d996e04b6a9c1901dd1f3e6839fcfd82117412ab378a4569bb552c606bd910ef"
    sha256 cellar: :any, arm64_tahoe:       "53e929b69d27121649d8cf292ef0640fd38b9d018def5af79327d85cb7f42d00"
    sha256 cellar: :any, arm64_sequoia:     "0c34d4aa78ed58b8f7f5afef98fd1d5e03d4d252a1449c45840e1ef295968507"
    sha256 cellar: :any, arm64_sonoma:      "d97772de06c89159cd2c755f8473be4d7e9792847c90409d376dd0ed6575372f"
    sha256 cellar: :any, arm64_linux:       "cfa41f73aa81b036581b9d8e3124e68bfe9fa68a22fd6ae33c6493c951ae3c3f"
    sha256 cellar: :any, x86_64_linux:      "4700685587f814bf850c1a31f62e18cdfe9855c6862ed487e39bd786a3535f83"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"
    spawn bin/"nanocat", "--rep", "--bind", bind, "--format", "ascii", "--data", "home"
    sleep 2
    output = shell_output("#{bin}/nanocat --req --connect #{bind} --format ascii --data brew")
    assert_match "home", output
  end
end
