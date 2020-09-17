class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.29/src/nspr-4.29.tar.gz"
  sha256 "22286bdb8059d74632cc7c2865c139e63953ecfb33bf4362ab58827e86e92582"
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
