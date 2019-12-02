class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "http://xmlsoft.org/sources/libxml2-2.9.10.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libxml2/libxml2-2.9.10.tar.gz"
  sha256 "aafee193ffb8fe0c82d4afef6ef91972cbaf5feea100edc2f262750611b4be1f"
  revision 1

  bottle do
    cellar :any
    sha256 "f23173c9ac3fa357cb1cfe511e4e5c48f28b8a06430b5a5849bb800c3357a1af" => :catalina
    sha256 "472ed1a73a91c49fd9f39bd8cc4a7472b09c691659b3b9305c9da42ed35e1475" => :mojave
    sha256 "cb117095b46da6b0ebac46ed0b867f3dfd8b448880d577b76c161a88e6f21302" => :high_sierra
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python@3.8"
  depends_on "readline"

  uses_from_macos "zlib"

  # Fix crash when using Python 3 using Fedora's patch.
  # Reported upstream:
  # https://bugzilla.gnome.org/show_bug.cgi?id=789714
  # https://gitlab.gnome.org/GNOME/libxml2/issues/12
  patch do
    url "https://bugzilla.opensuse.org/attachment.cgi?id=746044"
    sha256 "37eb81a8ec6929eed1514e891bff2dd05b450bcf0c712153880c485b7366c17c"
  end

  # Resolves CVE-2018-8048, CVE-2018-3740, CVE-2018-3741
  # Upstream hasn't patched this bug, but Nokogiri distributes
  # libxml2 with this patch to fixe this issue
  # https://bugzilla.gnome.org/show_bug.cgi?id=769760
  # https://github.com/sparklemotion/nokogiri/pull/1746
  patch do
    url "https://raw.githubusercontent.com/sparklemotion/nokogiri/38721829c1df30e93bdfbc88095cc36838e497f3/patches/libxml2/0001-Revert-Do-not-URI-escape-in-server-side-includes.patch"
    sha256 "c755e6e17c02584bfbfc8889ffc652384b010c0bd71879d7ff121ca60a218fcd"
  end

  def install
    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-history",
                          "--without-python",
                          "--without-lzma"
    system "make", "install"

    cd "python" do
      # We need to insert our include dir first
      inreplace "setup.py", "includes_dir = [",
                            "includes_dir = ['#{include}', '#{MacOS.sdk_path}/usr/include',"
      system Formula["python@3.8"].opt_bin/"python3", "setup.py", "install", "--prefix=#{prefix}"
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

    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import libxml2"
  end
end
