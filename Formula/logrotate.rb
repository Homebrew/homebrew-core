class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.20.1/logrotate-3.20.1.tar.xz"
  sha256 "742f6d6e18eceffa49a4bacd933686d3e42931cfccfb694d7f6369b704e5d094"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "20bb6473a71d54801b2d141f8bb5fd57211bc4f4df3ec9e1d5f4b3c650a33cd2"
    sha256 cellar: :any,                 arm64_big_sur:  "333fd71f9f463920a1a76f04cfdb700563477168d25675237a1863ec5fae8727"
    sha256 cellar: :any,                 monterey:       "91cd5a2ed4988f3de33a607d22b77c4f629aba32b550810c4e5f6956a355fe39"
    sha256 cellar: :any,                 big_sur:        "7fe8e0c87218bf3b58125ffea6278287d586855663c73a20ca8fa07d4d22737f"
    sha256 cellar: :any,                 catalina:       "fded0c8e4a465b9fbed0f83bb371f3b3d950c75ab0e9bb786591455f4401ef05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a3d7d0e82594615a2fd4c0912aba1fee56fde87477a155054e771ae25cd5eeb"
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
