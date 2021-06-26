class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.1.tar.gz"
  sha256 "8af684943836b8b53965d5f5b6714ef13c26c91eaa36ce7d242e3d21f5d40f2d"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f5338389f4d1ba865b01ea508c9d1f07edc83258a4161e6789aade42c3d11723"
    sha256 big_sur:       "5cdc0013d853962d6d3d3cc6c091a72f853bca9934d106dbe4046b20ee142055"
    sha256 catalina:      "1d9ba7c36ba4071f958f030dc99aabff2d84de58586aae737111add263959e0f"
    sha256 mojave:        "f99226cc8ab879de19a05ed036101e413c6fdc89b3cf4fcd83d1920dd3ad56f1"
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
