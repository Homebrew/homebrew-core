class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org"
  url "http://xmlsoft.org/sources/libxml2-2.9.5.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxml2-2.9.5.tar.gz"
  sha256 "4031c1ecee9ce7ba4f313e91ef6284164885cdb69937a123f6a83bb6a72dcd38"
  head "https://git.gnome.org/browse/libxml2.git"

  bottle do
    cellar :any
    sha256 "afd36afb4d3d51cb8bc5de392e9dc667d6e52b77e2887dc373ec5b9d69e8de47" => :sierra
    sha256 "d4fb605cef5b7508739ac0c9a459dfb193ecf65100c322929d4bb07bfaf9179a" => :el_capitan
    sha256 "2cb1c9ba0b6de38f0977ec7bf902bae11622881566e577a3378fd645e0ac6a76" => :yosemite
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
