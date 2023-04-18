class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.4.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn2-2.3.4.tar.gz"
  sha256 "93caba72b4e051d1f8d4f5a076ab63c99b77faee019b72b9783b267986dbb45f"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]
  revision 1

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "b044c66cc0f1feea87d229f3f4016c5ff29a0fb0f712d0d5219f05465247b10f"
    sha256 arm64_monterey: "64f5b404f308f58ea4dbe787559fb802abd9b624dabd9a1703aa241a2a86d0fb"
    sha256 arm64_big_sur:  "e6c723cf6d603fad95bc7c7110d114d879555c38c2bed239f5a3e977ecc29434"
    sha256 ventura:        "322028f5aaf50cac890a5eab03e3a21ecef83d76449c7d8f8d769d1c0887a7b7"
    sha256 monterey:       "5dcfc410f76c7885fffea633054c58c61e8a5dd2a6cfae33c2ea94e27ae0e96b"
    sha256 big_sur:        "234beba5f85ebd599ede74b4963e2cc5d2595e05b15bbe5bd528c8bc852bdc1d"
    sha256 x86_64_linux:   "af78945967847cdf33779abbd1142cabb31d6b5d428f367e23bc068f1d240e49"
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "gettext" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "ronn" => :build

    uses_from_macos "gperf" => :build

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libunistring"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = ["--disable-silent-rules", "--with-packager=Homebrew"]
    args << "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}" if OS.mac?

    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", *std_configure_args, *args
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
