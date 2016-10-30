class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.20.1/libslax-0.20.1.tar.gz"
  sha256 "59f8aace21fb7e02091da3b84de7e231d5d02af26401985b109d2b328ab3f09d"

  bottle do
    sha256 "a1a28522c18d2e2ee6db483a24d05f11434526ee01a0f30de88a1fd915409c58" => :sierra
    sha256 "05dc9585d259e452b4ae116f4885a854a17f01b5dad364559f51bd4540456e67" => :el_capitan
    sha256 "c5d5205c1cf54433d4e3c37cde10488c5b6f3c78cbe00c7b903c7c4f4e42e804" => :yosemite
    sha256 "6ebe095ba980ce574312cc694c2da90a12bd6e57c3016e0f9ed9f7acc56703b8" => :mavericks
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

  depends_on "libtool"  => :build
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
