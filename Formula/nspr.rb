class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.14/src/nspr-4.14.tar.gz"
  sha256 "64fc18826257403a9132240aa3c45193d577a84b08e96f7e7770a97c074d17d5"

  bottle do
    cellar :any
    sha256 "0482d14df015059c2909e607c067c27a8873d77d6434dfb723ea760622b84c28" => :sierra
    sha256 "322f31fbed4c7ab5a548969cea94f85e82580fb40160fdd3ecba2419b55c8bdc" => :el_capitan
    sha256 "ed6f24112fd590ed2a23fedcd324769c0c5528cce3f9defcd29f19dcc173ecb0" => :yosemite
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
