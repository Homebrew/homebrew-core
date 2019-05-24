class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.2.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.2.0.tar.gz"
  sha256 "fc734732b506d878753ec6606982bf7b936e868c25c30ddb0d83f7d7056381fe"

  bottle do
    sha256 "1bddaa4464445f918c144762158254ac72edbc1f7328467a259a03aeb7bd547d" => :mojave
    sha256 "a6521e744cfbdeefc38cba5b0b98d05f318a6bbebe8587c67d09b502dfeacdd4" => :high_sierra
    sha256 "492f6478e0759463dfd0ecb2246ecd2f5da153b5f2e0461f54a98634d7da70f0" => :sierra
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
