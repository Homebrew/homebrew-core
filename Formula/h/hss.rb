class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.9.tar.gz"
  sha256 "d7846ee657fe6a600c7d6f8e91f17ffa238efcaeb6f79856caa9fdedd96e3bca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a236cdb837ab620def9e04659cef476c55b046888dbc0c89047aca8e9fff865"
    sha256 cellar: :any,                 arm64_monterey: "b22fe721a066962a1673c52f8c1152b46c451cd4cfa3672158faefb24533fe5b"
    sha256 cellar: :any,                 arm64_big_sur:  "510fa3605e4d856cde1df1fd6af76db46b00b382738004931a6a59cfe78d1a4c"
    sha256 cellar: :any,                 ventura:        "30aee10929522aa5f226d171caf6c072fcc1ca552400262acd5c11c9992c9d07"
    sha256 cellar: :any,                 monterey:       "148418af9ede974ce97929a4d2203427b67d8cefd49001e8f70eaae68742b8dd"
    sha256 cellar: :any,                 big_sur:        "3b2888677612b095f03226c3a9cd1dbb788233dc909519021f38a4fcbed09a49"
    sha256 cellar: :any,                 catalina:       "64bb0e7f8de22316b5cabf7c805e4ce2948a7e44d4490e51bc3012c40acd59e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afddb5bd47b5545caddb3f178c318eae3074c07a417c194163316981067924a4"
  end

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    port = free_port
    begin
      server = TCPServer.new(port)
      accept_pid = fork do
        msg = server.accept.gets
        assert_match "SSH", msg
      end
      hss_read, hss_write = IO.pipe
      hss_pid = fork do
        exec "#{bin}/hss", "-H", "-p #{port} 127.0.0.1", "-u", "root", "true",
          out: hss_write
      end
      server.close
      msg = hss_read.gets
      assert_match "Connection closed by remote host", msg
    ensure
      Process.kill("TERM", accept_pid)
      Process.kill("TERM", hss_pid)
    end
  end
end
