class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.2.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.2.0.tar.gz"
  sha256 "fc734732b506d878753ec6606982bf7b936e868c25c30ddb0d83f7d7056381fe"
  revision 1

  bottle do
    sha256 "96e9b127a4123a1a4ec67f849467bbf9fafe79e7303ef2712c57bfb81b3c95d6" => :mojave
    sha256 "7c9da2a45d0f59ed9f973de3ca3820c10d55f70c8399496404425f64df1fa3cd" => :high_sierra
    sha256 "67896b703c38f761d313088af1237e5fc21e7f30aa06e2d6136bdb4758144c3d" => :sierra
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libunistring"

  def install
    if build.head?
      ENV["GEM_HOME"] = buildpath/"gem_home"
      system "gem", "install", "ronn"
      ENV.prepend_path "PATH", buildpath/"gem_home/bin"
      system "./bootstrap"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}",
                          "--with-packager=Homebrew"
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    ENV["CHARSET"] = "UTF-8"
    output = shell_output("#{bin}/idn2 räksmörgås.se")
    assert_equal "xn--rksmrgs-5wao1o.se", output.chomp
    output = shell_output("#{bin}/idn2 blåbærgrød.no")
    assert_equal "xn--blbrgrd-fxak7p.no", output.chomp
  end
end
