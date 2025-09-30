class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "https://github.com/Juniper/libslax/wiki"
  url "https://github.com/Juniper/libslax/releases/download/3.1.6/libslax-3.1.6.tar.gz"
  sha256 "e876068b343c54c40872fdb3c06749dd9cc4826f43fe4bd8247743070d51d9fb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "12f2c058552c9216221ff77a798f59590788193cca59a0755f152f94396cef16"
    sha256 arm64_sequoia: "6f6c93212b2fd3099e730116bee98ad61fa5c8bab6e20d6b54d27e20ae789ec5"
    sha256 arm64_sonoma:  "9b414bd048b9db9260c46345d5518559b1106d86b6ac318444acf4d6b2ef6605"
    sha256 arm64_ventura: "a9c26523a518372f3046748e74ebd0da8db2b1408d9bd5e641944a33b3338e67"
    sha256 sonoma:        "af1f73ee5a96a72a62f8fba2f0dfe5ef02e1fd17ac6d8d8176a0265c73a3ba0c"
    sha256 ventura:       "8d81b199e964178f69edc81aaf74f36358c8d364d41458d1ccfcba1e5291e61a"
  end

  head do
    url "https://github.com/Juniper/libslax.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on :macos # needs libxslt built --with-debugger
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "sqlite"

  conflicts_with "genometools", because: "both install `bin/gt`"
  conflicts_with "libxi", because: "both install `libxi.a`"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", "--enable-libedit", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<~EOS
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS

    system bin/"slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert_path_exists testpath/"hello.xslt"
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
