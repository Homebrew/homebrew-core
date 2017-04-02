class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.20.2/libslax-0.20.2.tar.gz"
  sha256 "2daa6c908eb03a4db4a701fce8b9cb269a2cc59d7adc70653cd4934c9662111b"

  bottle do
    sha256 "3b5e50d5e0009a3b80d7d2a0d488e51fa14ac2573bcc51e4acede622f40936de" => :sierra
    sha256 "ebc69e1268822dbfbbc1a116fb713ccbd42ca9155e96a399f8101b17e312a568" => :el_capitan
    sha256 "fdec6244e1e914e5959f0d0f3d3264d2ae09e522a009713306974b6f9e9e3869" => :yosemite
  end

  head do
    url "https://github.com/Juniper/libslax.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  if MacOS.version <= :mountain_lion
    depends_on "libxml2"
    depends_on "libxslt"
    depends_on "sqlite" # Needs 3.7.13, which shipped on 10.9.
  end

  depends_on "libtool" => :build
  depends_on "curl" if MacOS.version <= :lion
  depends_on "openssl"

  def install
    # configure remembers "-lcrypto" but not the link path.
    ENV.append "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"

    system "sh", "./bin/setup.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<-EOS.undent
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS
    system "#{bin}/slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert File.exist?("hello.xslt")
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
