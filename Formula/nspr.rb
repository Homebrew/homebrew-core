class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.28/src/nspr-4.28.tar.gz"
  sha256 "63defc8e19a80b6f98fcc7d5a89e84ea703c0b50aa6bc13bf7ad071adf433b56"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(/v(\d+(?:\.\d+)*)/i)
  end

  bottle do
    cellar :any
    sha256 "2ffd322e6891ff5f1dd608f0f71af699bffed06a6fa6f2a098bd64b2964e7e51" => :catalina
    sha256 "c429d78187edc727796ed385cd1f48b8aa4f8b297b22fcb4c5a9600f9eac988d" => :mojave
    sha256 "22b4c5397d3d8edcdf98f9bc8954345bf94421dbc0fa3dba8a23c15bf212dd2c" => :high_sierra
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
