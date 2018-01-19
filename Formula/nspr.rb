class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.18/src/nspr-4.18.tar.gz"
  sha256 "b89657c09bf88707d06ac238b8930d3ae08de68cb3edccfdc2e3dc97f9c8fb34"

  bottle do
    cellar :any
    sha256 "e90cc21f350aefb57ddb6e3f2c27e86e95fa9c7a9d7e40772a6603846b17a078" => :high_sierra
    sha256 "e28f7bf25551e93a29b2310b80b7e492323f42677ecbefc43b64d6e09e76b354" => :sierra
    sha256 "f083506086d7a0a72d90689f108d116a991e3da26c91416f6c980ff9fe59a9e7" => :el_capitan
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
