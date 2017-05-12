class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org"
  revision 2

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

    # https://bugzilla.gnome.org/show_bug.cgi?id=766834
    patch do
      url "https://git.gnome.org/browse/libxml2/patch/?id=3169602058bd2d04913909e869c61d1540bc7fb4"
      sha256 "42082b0e7fa80eac68abeace98ea5a03e8cd44cd781c13966eb0758b9a1749b3"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "08ae8ecc02d55f390122cb6a66e252720ff76ac003f3605a0ff1a700b8da32cd" => :sierra
    sha256 "935c1dc0821ca6c4676357c4a6a4339946f8a5d699b6da95f74380f098e61db1" => :el_capitan
    sha256 "eb7c876f407381400b8c64c9a3107aa50dc853823c4bbf2e856f32e93cb68bac" => :yosemite
  end

  head do
    url "https://git.gnome.org/browse/libxml2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_osx

  depends_on :python => :optional

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
    args = shell_output("#{bin}/xml2-config --cflags --libs").split
    args += %w[test.c -o test]
    system ENV.cc, *args
    system "./test"
  end
end
