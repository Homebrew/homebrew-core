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
            "patches/0007-Fix-more-NULL-pointer-derefs-in-xpointer.c.patch"
    end

    # https://bugzilla.gnome.org/show_bug.cgi?id=766834
    patch do
      url "https://git.gnome.org/browse/libxml2/patch/?id=3169602058bd2d04913909e869c61d1540bc7fb4"
      sha256 "42082b0e7fa80eac68abeace98ea5a03e8cd44cd781c13966eb0758b9a1749b3"
    end
  end

  bottle do
    cellar :any
    sha256 "ee3dbe9214cbd11f94f909262c11c5cd9d4a8e7c214a01f63c09aa678088caeb" => :sierra
    sha256 "682ab8b699edb23164a5a90e28099d9e532e0d2f99ff75ceab40ccbfc92bc494" => :el_capitan
    sha256 "df893d3e5c300697faae88cbece95fedf93ed838fc2274668f31b33e204cee21" => :yosemite
  end

  head do
    url "https://git.gnome.org/browse/libxml2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_osx

  option :universal

  depends_on :python => :optional

  def install
    ENV.universal_binary if build.universal?
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
