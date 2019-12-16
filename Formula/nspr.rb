class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.24/src/nspr-4.24.tar.gz"
  sha256 "90a59a0df6a11528749647fe18401cc7e03881e3e63c309f8c520ce06dd413d0"

  bottle do
    cellar :any
    sha256 "f98f2c3c4a5bbc2e43a2f7ed2cb653206d79827df2a39884395330aef9c5bfb2" => :catalina
    sha256 "bbec910100b9e29bf7581e0bef0a7ed977b7a8ebad092b92ba1105ead69002e8" => :mojave
    sha256 "657ed5c99f276bda1c48d6f8be34d5561f1c1579277a7fe4534aee95a2d97ec2" => :high_sierra
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
