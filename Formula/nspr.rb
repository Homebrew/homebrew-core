class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.17/src/nspr-4.17.tar.gz"
  sha256 "590a0aea29412ae22d7728038c21ef2ab42646e48172a47d2e4bb782846d1095"

  bottle do
    cellar :any
    sha256 "4f594ca361a2402f4d606a2e29897fcdb960920c09bf1d5d9665f63ba0d16761" => :high_sierra
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
