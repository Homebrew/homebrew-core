class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.21.0/logrotate-3.21.0.tar.xz"
  sha256 "8fa12015e3b8415c121fc9c0ca53aa872f7b0702f543afda7e32b6c4900f6516"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c1fd331eff062aadfffca8a276ddcc671b243959543740be3b18d0fa8043f6e2"
    sha256 cellar: :any,                 arm64_ventura:  "8e7e4ceaea1356aae5339c4b73e30357f2b5b7f2cd7885d088512e4424d587e6"
    sha256 cellar: :any,                 arm64_monterey: "69e5e0b7e048425a9f65032bed75319417cffd44e5139240de34a0186e217adf"
    sha256 cellar: :any,                 arm64_big_sur:  "412184f46ae0eb6a4c15c81349cccdfd1da979faa083aa21d72a9662198be08f"
    sha256 cellar: :any,                 sonoma:         "f55bbbb576c066529ef0f86e525a9f2fe55018b41d27f6d4863b129ce1a1b9b6"
    sha256 cellar: :any,                 ventura:        "bf4b7d1163c6506ea22cc96da7c830cf1fb7b7a9f5e5c2fe2f0373fae9d2ad99"
    sha256 cellar: :any,                 monterey:       "6e7b959f377ef96a40b1e25f8bf15a8aa0f05cde1d28e36ef2890d3d8239ef50"
    sha256 cellar: :any,                 big_sur:        "58a2d05ffa4b5350d1f9985aeda51a1db40040c5d845428820c0c205313547c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f471902687bec2d0e8ed417300938568118d9c86a5f0535f837bbb6e67b30ca"
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
