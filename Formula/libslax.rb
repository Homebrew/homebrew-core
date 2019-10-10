class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.22.1/libslax-0.22.1.tar.gz"
  sha256 "4da6fb9886e50d75478d5ecc6868c90dae9d30ba7fc6e6d154fc92e6a48d9a95"

  bottle do
    sha256 "40a8debf023cea878fa75996ec41dd1f1e56881096e6fbcabeb1c620b2ce6278" => :mojave
    sha256 "2628508f8181965f3d3c127cf305393536c89090d19bb2cb9a464ee13b2e236e" => :high_sierra
    sha256 "24ad984ed47a7b5c7ab09a6ea651f6c9de0b10d9426d3791b811efaa86248d35" => :sierra
  end

  head do
    url "https://github.com/Juniper/libslax.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  conflicts_with "genometools", :because => "both install `bin/gt`"

  def install
    # configure remembers "-lcrypto" but not the link path.
    ENV.append "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib}"

    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    system "sh", "./bin/setup.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<~EOS
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS
    system "#{bin}/slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert_predicate testpath/"hello.xslt", :exist?
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
