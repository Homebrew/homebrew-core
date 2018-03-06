class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.19/src/nspr-4.19.tar.gz"
  sha256 "2ed95917fa2277910d1d1cf36030607dccc0ba522bba08e2af13c113dcd8f729"

  bottle do
    cellar :any
    sha256 "19dc63255e248c8c5afd328965c4b2b1c8efa42380ccc1c1a798b27ab9b77a68" => :high_sierra
    sha256 "f834221bf6ff5f67a376c036363a7291d25f63a31edf12dd84dd842b8e3d0093" => :sierra
    sha256 "61684b922d36e616d4d1ba6e00470b82fbec08318a0a7204071245c614ff960e" => :el_capitan
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
