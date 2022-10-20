class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.3.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn2-2.3.3.tar.gz"
  sha256 "f3ac987522c00d33d44b323cae424e2cffcb4c63c6aa6cd1376edacbf1c36eb0"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e2d5ad350bd11194d179b2bf199103ce3a0f4aa57cca95fc8ac1f0bc104912c3"
    sha256 arm64_big_sur:  "8ff0838515b514f57fffa8964669815e5fe9e9fc21eeb559210e1f5634ac5483"
    sha256 monterey:       "1ed7a729a0e671778e89599ccf3df8536e41b95b30052827ee2a53a252a06519"
    sha256 big_sur:        "80fd3d0e971eb6b2620141249d863232a382b0db606d7e95923cf2f753a41e3a"
    sha256 catalina:       "fc09aa5df61b841c40a23490df6b2d556772c927520d7e0aac099029a11dd768"
    sha256 x86_64_linux:   "0ceff03509ea09a0784aa40b7b724f40857dfac8e9e34b36ee93570c57eb1780"
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
