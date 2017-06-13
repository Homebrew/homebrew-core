class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.22.0/libslax-0.22.0.tar.gz"
  sha256 "a32fb437a160666d88d9a9ae04ee6a880ea75f1f0e1e9a5a01ce1c8fbded6dfe"

  bottle do
    sha256 "7b8f9a2b5da09d32b9d0f45458a0059ebecddf7e40e49f667ad9c6c5f2a75d84" => :sierra
    sha256 "6c74666ce37951d72d6589914d203362195431324d89aeb7702c4d5574ebe17e" => :el_capitan
    sha256 "ac6582a698eae9f96d92d29b9e0ea1fb25b74c969e52cc1a97a1830ac6bb0544" => :yosemite
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
