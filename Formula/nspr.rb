class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.31/src/nspr-4.31.tar.gz"
  sha256 "5729da87d5fbf1584b72840751e0c6f329b5d541850cacd1b61652c95015abc8"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cc68066c04e374c88ae7d20ebf7093d5a58b1203481272de39554d5b0c46fbfe"
    sha256 cellar: :any, big_sur:       "097bb45f7541b47ecb45f3476da7aa0249f66681255c10a4f6081452083716e1"
    sha256 cellar: :any, catalina:      "683ef5685207c5c368c0ac2f0db3235f5b0f5d30d3fa53fcff1b805f815ab4de"
    sha256 cellar: :any, mojave:        "76cf099f7d02535352ac4bfd5b1c76bde37d891e40923cf0a32e1b8513e011e8"
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

      on_macos do
        # Remove the broken (for anyone but Firefox) install_name
        inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "
      end

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
