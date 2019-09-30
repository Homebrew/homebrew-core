class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.33.tar.gz"
  sha256 "8e36605144409df979cab43d835002f63988f3dc94d5d3537c12796db90e38c8"
  revision 1

  bottle do
    cellar :any
    sha256 "314e277e592dbf365edb6f170660778f0f928feb35749fce71a15555db9c7a0f" => :catalina
    sha256 "b59277228944c681b1f4df31b3b93c7dd410789a4c8e1b88a4f76bf82eead82c" => :mojave
    sha256 "ccc359c1c9471d16cb5a2a92b042d97d9f25bc2e7869841277c7db6323ad93fa" => :high_sierra
    sha256 "09151f46c7766d9a944bfce4fa5217c54e904f94324b6b3a1e9842ec4b688312" => :sierra
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "libxml2"

  def install
    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-libxml-prefix=#{Formula["libxml2"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    To allow the nokogiri gem to link against this libxslt run:
      gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
  end
end
