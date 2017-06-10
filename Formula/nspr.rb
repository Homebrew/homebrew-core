class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.15/src/nspr-4.15.tar.gz"
  sha256 "27dde06bc3d0c88903a20d6ad807361a912cfb624ca0ab4efb10fc50b19e2d80"

  bottle do
    cellar :any
    sha256 "b1f33b12d253a2b626b9927cec0f6656feab4f2e15498a94eab476f81a140b23" => :sierra
    sha256 "b3dfc884c4a3c56c7d2a2020d245994ada0df487846d13984632b938fac5019b" => :el_capitan
    sha256 "9e00336a77113aca800c43e60a23fc56797ea589e2a22abcca906ce7dfb21a4e" => :yosemite
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
