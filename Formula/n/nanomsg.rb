class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/refs/tags/1.2.2.tar.gz"
  sha256 "3ffeafa9335245a23a99827e8d389bfce5100610f44ebbe4bfaf47e8192d5939"
  license "MIT"
  head "https://github.com/nanomsg/nanomsg.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "236e9d3c6a8a96e0cab956bd5dfd22e598a0cde9648d9ca850e385aef13c876f"
    sha256 cellar: :any,                 arm64_sequoia: "2d674ed0ff11c730865b07f3110d650d88e097d27ea0ce62f39d96d2a59a6367"
    sha256 cellar: :any,                 arm64_sonoma:  "e9feaeab9e2f2b38117f1b62f682b6abeb86d41925bc329562c110e578c59f73"
    sha256 cellar: :any,                 sonoma:        "e3ee4bae6bf7df70c071c32fd0d12470406e146af552ee4de7f7701016a6609a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b03db650de3044ee4d0ed1bce200947e1018f34f76d4d06b9362ccae87134fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13450a2b72db7c3d7f91b65d2f8153d73caedecb378921d6cf9e386afea4d322"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nanocat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nanocat --req --connect #{bind} --format ascii --data brew")
    assert_match "home", output
  end
end
