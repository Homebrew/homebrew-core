class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.22.1/libslax-0.22.1.tar.gz"
  sha256 "4da6fb9886e50d75478d5ecc6868c90dae9d30ba7fc6e6d154fc92e6a48d9a95"

  bottle do
    sha256 "8b4506f10c72d75425ad849f17918a6574c349ebdf29ab740ad323811d1a4d02" => :catalina
    sha256 "5e024a22f8a47c0a11724d7543cd50141e8246b3669155cd734854ee74ec9d71" => :mojave
    sha256 "95e8b6bdc7010103110d8c7a92c33dd8e2e04228e037ca81c3a5cb69ea955ab2" => :high_sierra
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
