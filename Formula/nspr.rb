class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.14/src/nspr-4.14.tar.gz"
  sha256 "64fc18826257403a9132240aa3c45193d577a84b08e96f7e7770a97c074d17d5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5fbf42c7e328e0cd53a68e5c576dfc6ba255cc4df370c408962f25a3e838f433" => :sierra
    sha256 "d6782a241ae842311ef76eef2d3e348e17a1299d81efd8e03ffb5f602b741877" => :el_capitan
    sha256 "15ad0805bc563287c0cab50080cc34ba07543ec37c3ac91c490dbc25397df141" => :yosemite
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
