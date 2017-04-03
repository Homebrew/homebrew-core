class Libxml2AT27 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org"
  url "http://xmlsoft.org/sources/libxml2-2.7.8.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz"
  sha256 "cda23bc9ebd26474ca8f3d67e7d1c4a1f1e7106364b690d822e009fdc3c417ec"

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
