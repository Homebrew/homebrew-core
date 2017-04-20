class Libxml2AT27 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org"
  url "http://xmlsoft.org/sources/libxml2-2.7.8.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz"
  sha256 "cda23bc9ebd26474ca8f3d67e7d1c4a1f1e7106364b690d822e009fdc3c417ec"

  bottle do
    cellar :any
    sha256 "66e8a7e3bba96c9eb7ae9b9f58626298167dfa7524a920bc925fcccaf8d8a9f3" => :sierra
    sha256 "e162bd76f1ee1d35ccc3f0ab1ea961c3c3440bcf6a9006104bf15ccb8e5cf5df" => :el_capitan
    sha256 "f555a3fe75c9bc5c2e9fabea9795d0b71c6baeae54822c752686fcbd65bc2fb8" => :yosemite
  end

  keg_only :versioned_formula

  depends_on :python => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python"
    system "make"
    ENV.deparallelize
    system "make", "install"

    if build.with? "python"
      cd "python" do
        # We need to insert our include dir first
        inreplace "setup.py", "includes_dir = [", "includes_dir = ['#{include}', '#{MacOS.sdk_path}/usr/include',"
        system "python", "setup.py", "install", "--prefix=#{prefix}"
      end
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
    args = `#{bin}/xml2-config --cflags --libs`.split
    args += %w[test.c -o test]
    system ENV.cc, *args
    system "./test"
  end
end
