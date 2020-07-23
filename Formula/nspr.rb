class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.27/src/nspr-4.27.tar.gz"
  sha256 "6d495192b6ab00a3c28db053492cf794329f7c0351a5728db198111a1816e89b"
  license "MPL-2.0"

  bottle do
    cellar :any
    sha256 "70c30f08abf5a0499dcbe9d97061bd2c48d25ffaff0d435e8d7eede589f4c046" => :catalina
    sha256 "039c4d5ad25a611c6c62bd6542e1faa505a9fb4c4c43ac742b8ecaa947f85dd5" => :mojave
    sha256 "d94d9687669abfc4f85f2a275c5ab7bbb0f3f49873d6939a2def529910182459" => :high_sierra
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
