class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.16/src/nspr-4.16.tar.gz"
  sha256 "9b3102d97665504aeee73363c11a21c062ad67a2522242368b7f019f96a53cd1"

  bottle do
    cellar :any
    sha256 "1c651efa1235d579cae80dc8c0f626c16037c87183e831987fb4fc63a3a0ed3c" => :sierra
    sha256 "0ad1e250f6770a2d322f4abcbf9b7068aaa1bb9ad66da92d97b68d3f35d32132" => :el_capitan
    sha256 "43b35c3f35ee4705d91ce375759765e10e4d4400ad7d9dc58fced096d594972d" => :yosemite
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: https://openradar.appspot.com/7209349
      target_frameworks = Hardware::CPU.is_32_bit? ? "-framework Carbon" : ""
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
