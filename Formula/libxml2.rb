class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "http://xmlsoft.org/sources/libxml2-2.9.10.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libxml2/libxml2-2.9.10.tar.gz"
  sha256 "aafee193ffb8fe0c82d4afef6ef91972cbaf5feea100edc2f262750611b4be1f"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "bab6280370d9e7171d34e79ed1c1caa9b0b772ef7a1568f448a654255a505d5e" => :catalina
    sha256 "7185d4c64a25e546eaf525134210bfb21edffb0bfa93c122e4696ab3788cfbf3" => :mojave
    sha256 "bff3e730b9531c1b5088d49633a740eb27938961dc762b7de344e06d85ea20ee" => :high_sierra
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
