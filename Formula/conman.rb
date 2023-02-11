class Conman < Formula
  desc "Serial console management program supporting a large number of devices"
  homepage "https://github.com/dun/conman"
  url "https://github.com/dun/conman/archive/conman-0.3.1.tar.gz"
  sha256 "cd47d3d9a72579b470dd73d85cd3fec606fa5659c728ff3c1c57e970f4da72a2"
  license "GPL-3.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "freeipmi"

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Before starting the conmand service, configure some consoles in #{etc}/conman.conf.
    EOS
  end

  service do
    run [opt_sbin/"conmand", "-F", "-c", etc/"conman.conf"]
    keep_alive true
  end

  test do
    system bin/"conman", "-V"
    system sbin/"conmand", "-V"
  end
end
