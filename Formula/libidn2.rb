class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.2.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn2-2.3.2.tar.gz"
  sha256 "76940cd4e778e8093579a9d195b25fff5e936e9dc6242068528b437a76764f91"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "fcc51d2c385b19d647da5a53f7041f13f97d2c1119a7cbbfd8433e9e55bf5012"
    sha256 arm64_big_sur:  "dbaac7e6e29ffa8c7c2b5e152fd6ee0118e547f90dc4b180c7f168c2f681c5f4"
    sha256 monterey:       "29b1ea810ddad662b0c766429c2384495d643baa253dc31eed0300f5d4c4d7f4"
    sha256 big_sur:        "d21350f576f9b9cd0512149164622671b71854da69947183bc84e09a3a257b89"
    sha256 catalina:       "71c5f183ae570f9a77eb759ab2bd04d84eb5cb9cf9c9a3b7cd8879aad5966bcd"
    sha256 mojave:         "9402e3774f00c5485dd341cf34c35c24de0dc9bb90b2d4057c22e432848e0f1f"
    sha256 x86_64_linux:   "57a2bf8955bcc8c2661aec2b26acfb90ec50402d78afebb000a1f6b0c27421e4"
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
