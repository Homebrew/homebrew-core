class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.34.tar.gz"
  sha256 "98b1bd46d6792925ad2dfe9a87452ea2adebf69dcb9919ffd55bf926a7f93f7f"

  bottle do
    cellar :any
    sha256 "cbadecf3186f45754220dff4cbdfbb576882a211d615b52249a4c9d8ba4d7c3a" => :catalina
    sha256 "6feb1b8d57dd0d8b651733720d4dac728d2e27cf8c9fa9f88e60612fe0a0c882" => :mojave
    sha256 "733c15b756070866d08196dcd5eef9facea1ce98d9c233cd6bf73fa426e0d062" => :high_sierra
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

  def caveats
    <<~EOS
      To allow the nokogiri gem to link against this libxslt run:
        gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
  end
end
