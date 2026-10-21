class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/refs/tags/1.3.0.tar.gz"
  sha256 "acf65c0ef312f431aa3c4cb114326781c999ec0c977067f3a1f0c81b5ec8710f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/nanomsg/nanomsg.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "118a329cf8fa7ba1413d3b4e56da306b43403110eb0a1ab0ce5234272b69756a"
    sha256 cellar: :any, arm64_tahoe:       "28d2002dd4f7bab3b2046c2f01c9005329de6a175f2d78aaad73aa777b78e9dc"
    sha256 cellar: :any, arm64_sequoia:     "4b1f8eb7f0c574600f37d1e9b712bb68e00922a9d957e726cae2369e0bb65289"
    sha256 cellar: :any, arm64_linux:       "4b86a05b539399bd42b1c5a9278a048f52effe05f8d6712b430d47f4673564b5"
    sha256 cellar: :any, x86_64_linux:      "bca470fa3dc0ff0013b3ea2630750601ca30381bddce692a17d8dc31476462df"
  end

  depends_on "cmake" => :build

  allow_network_access! :test

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
