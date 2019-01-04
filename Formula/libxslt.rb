class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.33.tar.gz"
  sha256 "8e36605144409df979cab43d835002f63988f3dc94d5d3537c12796db90e38c8"

  bottle do
    sha256 "9ec247ef3cb3dcb30a5f2392150ef3323e49c5270d959cec3ffb008c2192ad52" => :mojave
    sha256 "502430d08fb7c8d0462ca5421b66caee4d9b8e39f3c7460c2bfca91be37091f9" => :high_sierra
    sha256 "5d68588f3afbdd93022aeaf81b9c6403c0c6b8aac24e5ba25a195c5ec5bad7e5" => :sierra
    sha256 "66854da0ffbb83f60863c23b985e5522037db4957aca70e2b49346a243a30991" => :el_capitan
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

    # https://bugzilla.gnome.org/show_bug.cgi?id=762967
    inreplace "configure", /PYTHON_LIBS=.*/, 'PYTHON_LIBS="-undefined dynamic_lookup"'

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
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
