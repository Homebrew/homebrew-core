class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "https://github.com/stvchu/memcacheq"
  url "https://github.com/stvchu/memcacheq/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ace33313568959b5a301dda491f63af09793987b73fd15abd3fb613829eda07e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f056c80f984e46a6a4d683ff08eb5832a19d589fc6c0824d75c4d749655fbe2b"
    sha256 cellar: :any,                 arm64_sonoma:   "36f7c155704e3578ad22f4d8f1d6537a1720ebaba29abb52f61cb2d0d602bcd9"
    sha256 cellar: :any,                 arm64_ventura:  "76a6335c95617676d29dc17b89faa4871f1b48308bab35117fe3d59def21c621"
    sha256 cellar: :any,                 arm64_monterey: "a9be9de387a93adf837f45192ce234676c7d4199b39fa0ff4c21ea025c9e1956"
    sha256 cellar: :any,                 arm64_big_sur:  "4bb8a364aa6925ca5fcb284820ac82fe0f895012315af6fa04778d8386cd3baa"
    sha256 cellar: :any,                 sonoma:         "3810a30b96066af87a36c3992f21f1a69215836eaad0033732915f89a7aa0bc5"
    sha256 cellar: :any,                 ventura:        "ef734a22aee16914c5d7bfb969c536ad3b502a0d2dce6e26af6982d4f3d455d5"
    sha256 cellar: :any,                 monterey:       "83abbc744c310b7afed5a767db77e20b3be0a1289cc5474d018a8cfb0dc368de"
    sha256 cellar: :any,                 big_sur:        "0fcdae22ade43e314bd26fe48a6a43a97592ccce1445336d83f90d9204a4daad"
    sha256 cellar: :any,                 catalina:       "10cc27ffb5112ca2570fcfc372993048a10b2a22a69f499424f7739219e45d8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2c2620ce9e5212fa2cf38b5397a8f7438d5fab43135925dead98f7a850d543ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00507c2726969f342d96813393cc9fafe2073edd4075eb473ea8a86fa47129bf"
  end

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "libevent"

  uses_from_macos "netcat" => :test

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--enable-threads", *std_configure_args
    system "make", "install"
  end

  test do
    port = free_port
    pid = spawn(bin/"memcacheq", "-p", port.to_s, "-H", testpath)
    sleep 5
    assert_match "STORED", pipe_output("nc localhost #{port}", "set brew 2 0 3\r\n100\r\n", 0)
    assert_equal "STAT brew 1/0\r\nEND\r\n", pipe_output("nc localhost #{port}", "stats queue\r\n", 0)
    assert_equal "VALUE brew 2 3\r\n100\r\nEND\r\n", pipe_output("nc localhost #{port}", "get brew\r\n", 0)
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
