class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.19/src/nspr-4.19.tar.gz"
  sha256 "2ed95917fa2277910d1d1cf36030607dccc0ba522bba08e2af13c113dcd8f729"

  bottle do
    cellar :any
    sha256 "e422c79b0be3e83e776034c41583ff7321b23b627b0e8de577615a1546fcc3b9" => :high_sierra
    sha256 "d58d218efa11c262e774476d5ca85a9b0e239c6c5c01f2b11cb0c43d2c31b0df" => :sierra
    sha256 "437a7baf3aaddbcfe35b4a51351c3993e92b8f82b1171759a76ea144da3a5100" => :el_capitan
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: https://openradar.appspot.com/7209349
      target_frameworks = Hardware::CPU.is_32_bit? ? "-framework Carbon" : ""
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
