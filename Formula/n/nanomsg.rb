class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/refs/tags/1.2.4.tar.gz"
  sha256 "be255a26452400a6ff79039e1c76592694bc602e7b1e0c40a64b841ba0e434ed"
  license "MIT"
  head "https://github.com/nanomsg/nanomsg.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "50c6516a86030cbd91d73602d7d0d6f6128fda0402350e726dd7325e72ea1360"
    sha256 cellar: :any, arm64_sequoia: "de0df18a43425a6207735394523dd5db76786c8be145b4b94a2c13eea7292e91"
    sha256 cellar: :any, arm64_sonoma:  "ea96ba83b9e1f442fe84c397b20e1135c80fd2d79b50073af2c6f2ca161cbe50"
    sha256 cellar: :any, sonoma:        "f979caeeda756a5555f7d490214026c675ef9f630d99a7fc48484252f9c64db4"
    sha256 cellar: :any, arm64_linux:   "7b3139cada267ee03c2b867d9f9f11213275fec0f399ade09a88ca0dd271e178"
    sha256 cellar: :any, x86_64_linux:  "7470de366576351a9d17e99df46cbba2bdd4d1a042203486debf44b4c9431505"
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
