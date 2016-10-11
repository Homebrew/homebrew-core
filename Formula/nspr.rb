class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.12/src/nspr-4.12.tar.gz"
  sha256 "e0b10a1e569153668ff8bdea6c7e491b389fab69c2f18285a1ebf7c2ea4269de"
  revision 1

  bottle do
    cellar :any
    sha256 "50c7850cb2b11a78c73c7b8fe5f28cea5232680835ca7c5497db11af2f3b4b57" => :sierra
    sha256 "7c138d3779c7b41b0550135daa961795beb3e30ffe011ef3a9644cf6b67f23bf" => :el_capitan
    sha256 "1a6ed93d051c82a262b0c29515628dfbfce6863adf9a6d17e6e3187d2bb145d4" => :yosemite
    sha256 "bd3bc70ebe4eec5594ab98b85634f896b6a00cee7c86c29dc7b083da437ba886" => :mavericks
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
