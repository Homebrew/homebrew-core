class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.13.1/src/nspr-4.13.1.tar.gz"
  sha256 "5e4c1751339a76e7c772c0c04747488d7f8c98980b434dc846977e43117833ab"

  bottle do
    cellar :any
    sha256 "5b972362ade2eda9ef35e0ba88e0b8a1403f0bc61096c58972cbae3c4efae752" => :sierra
    sha256 "e7c3d3cc5084a1c347620dd0a06124f3cf66a5258836e0e1dfe3ef8a1bccb57b" => :el_capitan
    sha256 "2874f8346247f57822e8d4214b5ab01fd05ba079fd29714656761fc1764405a0" => :yosemite
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: https://openradar.appspot.com/7209349
      target_frameworks = (Hardware::CPU.is_32_bit? || MacOS.version <= :leopard) ? "-framework Carbon" : ""
      inreplace "pr/src/Makefile.in", "-framework CoreServices -framework CoreFoundation", target_frameworks

      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-macos-target=#{MacOS.version}
      ]
      args << "--enable-64bit" if MacOS.prefer_64_bit?
      system "./configure", *args
      # Remove the broken (for anyone but Firefox) install_name
      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "

      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end
end
