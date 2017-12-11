class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.0.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/libidn/libidn2-2.0.4.tar.gz"
  sha256 "644b6b03b285fb0ace02d241d59483d98bc462729d8bb3608d5cad5532f3d2f0"

  bottle do
    sha256 "e2331d3c771fb283c2e995f33ec65f233d3fa4fe53f68818e94a0813acd9b591" => :high_sierra
    sha256 "eede4f7d455f28a987941586c3bf01ee0e6d60af6a16bd4ee908af85d67383d7" => :sierra
    sha256 "5e3e5c3247175111eea66f46a09385adc481bbe1c0c375284dc157c22db8d869" => :el_capitan
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
