class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.22/src/nspr-4.22.tar.gz"
  sha256 "c9e4b6cc24856ec93202fe13704b38b38ba219f0f2aeac93090ce2b6c696d430"

  bottle do
    cellar :any
    sha256 "df7f55099d7210f68306857a154677cfffe0bfc03a782674c8424a8f1dfe4e5e" => :mojave
    sha256 "4ebdabe6497e0f587aa034628469de65b57e7eec1450f7f580474f1a44c18078" => :high_sierra
    sha256 "178fed703fb7a103c5f950f7d1da11e93caec34540be7ed37a94c7fa7524238d" => :sierra
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
