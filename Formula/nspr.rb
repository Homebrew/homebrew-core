class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.23/src/nspr-4.23.tar.gz"
  sha256 "4b9d821037faf5723da901515ed9cac8b23ef1ea3729022259777393453477a4"

  bottle do
    cellar :any
    sha256 "ae8ddaf4515104ade295b6474b2964a1327cdc2133e83e942d249fead9970b53" => :catalina
    sha256 "9203fbc1294b61227f918935e0d59e21a0b65b0e5374349b7525f01793188d5c" => :mojave
    sha256 "eae0aeb8a3cc008d08d5eb6d97ef1e7c0c0f91bb4504967a569cb5eaf0824908" => :high_sierra
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
