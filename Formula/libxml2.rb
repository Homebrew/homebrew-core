class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org"
  url "http://xmlsoft.org/sources/libxml2-2.9.6.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxml2-2.9.6.tar.gz"
  sha256 "8b9038cca7240e881d462ea391882092dfdc6d4f483f72683e817be08df5ebbc"
  head "https://git.gnome.org/browse/libxml2.git"

  bottle do
    cellar :any
    sha256 "c34f1308c810427cd88e8ac4cadd71b9e65fe6b44bc54e5249dfaa785aaae661" => :high_sierra
    sha256 "b1121510780bcd6ae1a464f22312bb425daff8735dd2c647b41484461f646a7a" => :sierra
    sha256 "09b8d61b8ae67820a739c240f4114079911a019390a6ed2fee8541439dc53660" => :el_capitan
    sha256 "1fd3f3ec30d85289019b6845d5b394f4ab38c7543ef0a7aa3948c76c7dd3ce93" => :yosemite
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
