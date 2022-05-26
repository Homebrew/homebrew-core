class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.20.1/logrotate-3.20.1.tar.xz"
  sha256 "742f6d6e18eceffa49a4bacd933686d3e42931cfccfb694d7f6369b704e5d094"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "911af87337001ec3d38954d3e0d7b5bd725b1e4c9e6520f752d3867037b943d1"
    sha256 cellar: :any,                 arm64_big_sur:  "c0abbacfd91edcfae10d2e811db6f32945a16d27f06a19fec2e9b51991099a82"
    sha256 cellar: :any,                 monterey:       "3f2dd0191cdd96fc9ac793a978e8fcd36c390ec7f6ea5025e6bd12aeaa7d0285"
    sha256 cellar: :any,                 big_sur:        "cac5137054b18b313f392e4b6e6c4c63f0ae76dbc9a9fa054b0bbb51bb4ddea5"
    sha256 cellar: :any,                 catalina:       "386d465500e1750d4fcf8be93248e3229a1a70590ec3385ef82f549b9ca76354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadb898b459ca71b6dfb3f25bda4b2c21df73ce6b56da4f8cef3738206d00568"
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
