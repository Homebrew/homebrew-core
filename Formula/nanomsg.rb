class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.5.tar.gz"
  sha256 "218b31ae1534ab897cb5c419973603de9ca1a5f54df2e724ab4a188eb416df5a"
  license "MIT"
  head "https://github.com/nanomsg/nanomsg.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "86a6e6d8764bc3b276ff9f96d28390153d5287c22293124203af015e62df50d3" => :big_sur
    sha256 "87ca8b11ff0c9645bcf2d30e25ef03ee957ac9187677ec03d194417ef76d3e5e" => :arm64_big_sur
    sha256 "81cd453e3fdf65da66a54fda36c84248a1eb923ac92125fd14bdf68989aeb9b7" => :catalina
    sha256 "95609047c54b0207587db3a5b3cc8985b35fc922fe8785c63d4d2a44a78ff57f" => :mojave
    sha256 "11390e904a94e60865186a846af14565b379ec84942a9bc512ba4e5e3ea7ec85" => :high_sierra
    sha256 "95192ebc59926ff064d7f4cff5ebf9037c7549af61d2f1c23375827c91b88282" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nanocat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nanocat --req --connect #{bind} --format ascii --data brew")
    assert_match /home/, output
  end
end
