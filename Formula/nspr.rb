class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.25/src/nspr-4.25.tar.gz"
  sha256 "0bc309be21f91da4474c56df90415101c7f0c7c7cab2943cd943cd7896985256"

  bottle do
    cellar :any
    sha256 "d1b37153ae32255e1c6a851c497f1d6a81b9580403e889d0a2d77266e5aaf54a" => :catalina
    sha256 "4ea0a985bdca85cc08510a2a8e5f1aa2d295bcd0bc2fc048b174f9432c4eb8bc" => :mojave
    sha256 "7d66be141d5cfd5bb1e62ebc7c6fef92a40f1cbd1cc596b1d2d014a356016184" => :high_sierra
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
