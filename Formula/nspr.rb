class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.21/src/nspr-4.21.tar.gz"
  sha256 "15ea32c7b100217b6e3193bc03e77f485d9bf7504051443ba9ce86d1c17c6b5a"

  bottle do
    cellar :any
    sha256 "7263b00a86a15844b36baedf684fce6bc2b1608cfa4759353dad6005f02e2789" => :mojave
    sha256 "2f81a6af2ef8632567e45e0a1b442b33583da98ed968aeda7e167caaf38bf11a" => :high_sierra
    sha256 "4b1c5d6e2e7a758c58594c569606650f4ef831b280735d5a1cc58e3201ca716e" => :sierra
    sha256 "d2863a8a722ad55128333d635774c2ce3de0300000648c39fc61748f638b6320" => :el_capitan
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: https://openradar.appspot.com/7209349
      inreplace "pr/src/Makefile.in", "-framework CoreServices -framework CoreFoundation", ""

      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-macos-target=#{MacOS.version}
        --enable-64bit
      ]
      system "./configure", *args
      # Remove the broken (for anyone but Firefox) install_name
      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "

      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end

  test do
    system "#{bin}/nspr-config", "--version"
  end
end
