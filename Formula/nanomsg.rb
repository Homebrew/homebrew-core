class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.5.tar.gz"
  sha256 "218b31ae1534ab897cb5c419973603de9ca1a5f54df2e724ab4a188eb416df5a"
  license "MIT"
  head "https://github.com/nanomsg/nanomsg.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "db706d4dd4d8eb9ea4a1c90a211b793e04583d62d8ef7ac60410330200c11e88"
    sha256                               arm64_big_sur:  "87ca8b11ff0c9645bcf2d30e25ef03ee957ac9187677ec03d194417ef76d3e5e"
    sha256 cellar: :any,                 monterey:       "3f59f226fe111172467d9d7d187aa486659e5b58abc3571b6612b544d4dc43e9"
    sha256                               big_sur:        "86a6e6d8764bc3b276ff9f96d28390153d5287c22293124203af015e62df50d3"
    sha256                               catalina:       "81cd453e3fdf65da66a54fda36c84248a1eb923ac92125fd14bdf68989aeb9b7"
    sha256                               mojave:         "95609047c54b0207587db3a5b3cc8985b35fc922fe8785c63d4d2a44a78ff57f"
    sha256                               high_sierra:    "11390e904a94e60865186a846af14565b379ec84942a9bc512ba4e5e3ea7ec85"
    sha256                               sierra:         "95192ebc59926ff064d7f4cff5ebf9037c7549af61d2f1c23375827c91b88282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7b86a0e81583a24dabfbbb58cf5d72b7b107cfd8dfd7b8f1f652de0dd3db9b4"
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
    assert_match "home", output
  end
end
