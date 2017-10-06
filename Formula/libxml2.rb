class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org"
  url "http://xmlsoft.org/sources/libxml2-2.9.6.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxml2-2.9.6.tar.gz"
  sha256 "8b9038cca7240e881d462ea391882092dfdc6d4f483f72683e817be08df5ebbc"
  head "https://git.gnome.org/browse/libxml2.git"

  bottle do
    cellar :any
    sha256 "b08291d2d8b9328b55a7785128d57a893b5d0eb3c03cb528316d6cabc93dbf37" => :high_sierra
    sha256 "7aae3bbeb817110901ddc03112b6a5af7c8f457149c7cc9852ff16c1740a8f75" => :sierra
    sha256 "c3638a6edc119734a626d84d50d2bbc22bb170455dce1eff589560ad79cc5378" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on :python if MacOS.version <= :snow_leopard

  # These should return to being head-only whenever 2.9.5 is released.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--without-lzma"
    system "make"
    ENV.deparallelize
    system "make", "install"

    cd "python" do
      # We need to insert our include dir first
      inreplace "setup.py", "includes_dir = [", "includes_dir = ['#{include}', '#{MacOS.sdk_path}/usr/include',"
      system "python", "setup.py", "install", "--prefix=#{prefix}"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libxml/tree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    EOS
    args = shell_output("#{bin}/xml2-config --cflags --libs").split
    args += %w[test.c -o test]
    system ENV.cc, *args
    system "./test"

    ENV.prepend_path "PYTHONPATH", lib/"python2.7/site-packages"
    system "python", "-c", "import libxml2"
  end
end
