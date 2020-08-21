class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.28/src/nspr-4.28.tar.gz"
  sha256 "63defc8e19a80b6f98fcc7d5a89e84ea703c0b50aa6bc13bf7ad071adf433b56"
  license "MPL-2.0"

  bottle do
    cellar :any
    sha256 "a9ad990acb59b9578b81d9875d3bdc7633ce21552af014ef77e8b0d07ab94983" => :catalina
    sha256 "f5bd7b904233ba05c23bb33ca290ce14605999f8ae97a8eb12c2c06320a39772" => :mojave
    sha256 "5da91b9a45b0ff47d1ff9cf0c77295b68029a73b0cb71cde25d3f632443c9ee7" => :high_sierra
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
