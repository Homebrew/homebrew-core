class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.1.1a.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.1.1a.tar.gz"
  sha256 "57666bcf6ecf54230d7bac95c392379561954b57a673903aed4d3336b3048b72"

  bottle do
    sha256 "375378c094e99ec8da0cf14d5cf8e70bca64ac594e2c0728c961be3999f9f190" => :mojave
    sha256 "cfd16003972857e45c78dc430a3a6bc0c796443bc9719ada9a8d6aaa968a1c8a" => :high_sierra
    sha256 "fb471fcee9c5c9f527cd77e9a5e3c42a9532c12dd6211d65f2780988cd1bb630" => :sierra
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
