class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.19.0/logrotate-3.19.0.tar.xz"
  sha256 "ddd5274d684c5c99ca724e8069329f343ebe376e07493d537d9effdc501214ba"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "01b5f400fbc9bc6c8e694b205bd625bd046d12c86f39cf1042cee15873309d27"
    sha256 cellar: :any,                 arm64_big_sur:  "1cfa4ceedd3e7bf227a7950d865c5439666ad16e0c051f88b3771daa93bc7a47"
    sha256 cellar: :any,                 monterey:       "8266898c6d82f2ca10fa95c40811712e6059a790674f6bcd8cc3b94825a9bab5"
    sha256 cellar: :any,                 big_sur:        "134e05229e94e1b550472237d11983763684d23797e999442958ca481e88820e"
    sha256 cellar: :any,                 catalina:       "ae3079d10750c31c48027a8dbf3b1b132379cf0ce8c9e7c2358421e63b9ddc70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36257395bf87b366af182e783176cc7cf72087113c9d5e6de63751436eeec327"
  end

  depends_on "popt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-compress-command=/usr/bin/gzip",
                          "--with-uncompress-command=/usr/bin/gunzip",
                          "--with-state-file-path=#{var}/lib/logrotate.status"
    system "make", "install"

    inreplace "examples/logrotate.conf", "/etc/logrotate.d", "#{etc}/logrotate.d"
    etc.install "examples/logrotate.conf" => "logrotate.conf"
    (etc/"logrotate.d").mkpath
  end

  service do
    run [opt_sbin/"logrotate", etc/"logrotate.conf"]
    run_type :cron
    cron "25 6 * * *"
  end

  test do
    (testpath/"test.log").write("testlograndomstring")
    (testpath/"testlogrotate.conf").write <<~EOS
      #{testpath}/test.log {
        size 1
        copytruncate
      }
    EOS
    system "#{sbin}/logrotate", "-s", "logstatus", "testlogrotate.conf"
    assert(File.size?("test.log").nil?, "File is not zero length!")
  end
end
