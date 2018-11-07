class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libxml2/libxml2-2.9.8.tar.gz"
  sha256 "0b74e51595654f958148759cfef0993114ddccccbb6f31aee018f3558e8e2732"

  bottle do
    cellar :any
    sha256 "ca9b29ed2907efd2f9cd8b65e8f5c5683bfb8c92aede1d3fbda9325f4d25c59c" => :mojave
    sha256 "ff9bf7d946d5413fb1f2837a187bd026f469a67b78ba6589f5b565f0133b58f2" => :high_sierra
    sha256 "0b9bc0fe308a22b557822d0bc254f209e33bd7b4948d7d08a14d620e1f8b6a3b" => :sierra
    sha256 "cdcc13eab3436e1c44dcae42396e519e4a5119552818b656a2c7a5d878b9a912" => :el_capitan
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python@2"

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--without-lzma"
    system "make", "install"

    cd "python" do
      # We need to insert our include dir first
      inreplace "setup.py", "includes_dir = [", "includes_dir = ['#{include}', '#{MacOS.sdk_path}/usr/include',"
      system "python", "setup.py", "install", "--prefix=#{prefix}"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    system "python2.7", "-c", "import libxml2"
  end
end
