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
    sha256 arm64_big_sur: "eb8e6de157329d032c3d3343b15b75896c4bb3aa8bec3fd11055757ddb467827"
    sha256 big_sur:       "65523d89d65893a402f9f2641793314d5c18f5ba115400ef6ad372b8c177ebd9"
    sha256 catalina:      "0908585cca518a83f101b2edc0417a26a4b4fc8b76e393c6f6672de6e595c914"
    sha256 mojave:        "d56e7ff347b0a4c2c433cd44564dfef74c9f1b237ef913307e152314677e1360"
    sha256 high_sierra:   "4530dd74cbd31c49b0f499eda0f9ea29ec7ff6ae00f9aff3974247365d1fb21e"
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
