class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.2.tar.gz"
  sha256 "76940cd4e778e8093579a9d195b25fff5e936e9dc6242068528b437a76764f91"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "01ffa4ee0e56a4190329e352543a2c11eb13801f0ec19577e37ef89440679504"
    sha256 big_sur:       "25c6ccfc501690f453ebcb4ce56609bcfa3ba915da6dd29ecbf9afe0e3ef321b"
    sha256 catalina:      "0ca13baf4da29a9a0fd0f4bab818318f0c555d1dfab586ed3addfc5a716f3440"
    sha256 mojave:        "b2707eb113d2a31e0e1ca8385777939948f71a78d2312085f15b2df8c79581af"
    sha256 x86_64_linux:  "a907fb49867f904848a3df8ea38dc57f7196c43914de74c46a2de69ba65607a1"
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "libtool" => :build
    depends_on "ronn" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libunistring"

  def install
    system "./bootstrap" if build.head?

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
