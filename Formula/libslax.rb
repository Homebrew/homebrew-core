class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.20.1/libslax-0.20.1.tar.gz"
  sha256 "59f8aace21fb7e02091da3b84de7e231d5d02af26401985b109d2b328ab3f09d"

  bottle do
    revision 1
    sha256 "d93e089b6a8f9332a0faad4292e55c32db5122bd6b1d14f9d110bae0596c05c7" => :el_capitan
    sha256 "9faa71033a275aeb2b232543ad61ef09fe069ece4794cc28d2c03b8cd83dc9b5" => :yosemite
    sha256 "5108fa8d5db98f2a8441bb90c860ea01302afe935089be162f6a5164aa56fedd" => :mavericks
    sha256 "a29d332d5fd18e9903e891018ed8c3f527efc7fe95029e219b3d5e1e4e4a5c47" => :mountain_lion
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
