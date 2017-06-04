class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org"
  revision 3

  stable do
    url "http://xmlsoft.org/sources/libxml2-2.9.4.tar.gz"
    mirror "ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz"
    sha256 "ffb911191e509b966deb55de705387f14156e1a56b21824357cdf0053233633c"

    # All patches upstream already. Remove whenever 2.9.5 is released.
    # Fixes CVE-2016-4658, CVE-2016-5131.
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libx/libxml2/libxml2_2.9.4+dfsg1-2.2.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libx/libxml2/libxml2_2.9.4+dfsg1-2.2.debian.tar.xz"
      sha256 "c038bba02a56164cef7728509ba3c8f1856018573769ee9ffcc48c565e90bdc9"
      apply "patches/0003-Fix-NULL-pointer-deref-in-XPointer-range-to.patch",
            "patches/0004-Fix-comparison-with-root-node-in-xmlXPathCmpNodes.patch",
            "patches/0005-Fix-XPointer-paths-beginning-with-range-to.patch",
            "patches/0006-Disallow-namespace-nodes-in-XPointer-ranges.patch",
            "patches/0007-Fix-more-NULL-pointer-derefs-in-xpointer.c.patch",
            "patches/0008-Fix-attribute-decoding-during-XML-schema-validation.patch"
    end
  end

  bottle do
    cellar :any
    sha256 "fb8338703ee9691cc48ca8898a16baa3b2657635ebacb6071dee49725bd052d6" => :sierra
    sha256 "04751be7609addc8fef6fa5cfd0413fbec46cbe2a0bab3fe52ff98371356eb87" => :el_capitan
    sha256 "1ec98ced07f46c0976bd919fe97cf72092a28c1338d43410384d37f6439634c0" => :yosemite
  end

  head do
    url "https://git.gnome.org/browse/libxml2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_osx

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

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
