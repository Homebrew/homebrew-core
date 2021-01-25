class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "http://xmlsoft.org/sources/libxml2-2.9.10.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libxml2/libxml2-2.9.10.tar.gz"
  sha256 "aafee193ffb8fe0c82d4afef6ef91972cbaf5feea100edc2f262750611b4be1f"
  license "MIT"
  revision 2

  livecheck do
    url "http://xmlsoft.org/sources"
    regex(/href=.*?libxml2[._-]v?([\d.]+\.[\d.]+\.[\d.]+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "0170a16da823ce77d1aad7db927b23a1adb12285a174f36a918275d7952eaaae" => :big_sur
    sha256 "c2e1bb939465a54e70ac4a6a8c333d00bc01a3738037f77cfd2227e47053ff47" => :arm64_big_sur
    sha256 "2983d5a448504389888720bf951713114ed7f010d96cde9289fdc5c4b539d303" => :catalina
    sha256 "7bcd780db5693475c7711eefbbcf703507865e06483e7338ab61027ec375c4bc" => :mojave
    sha256 "34d84eaef7f80632a6547903d640be06c6d92b9ca2b815b64b74943b4cf73e63" => :high_sierra
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python@3.9"
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
  # libxml2 with this patch to fix this issue
  # https://bugzilla.gnome.org/show_bug.cgi?id=769760
  # https://github.com/sparklemotion/nokogiri/pull/1746
  patch do
    url "https://raw.githubusercontent.com/sparklemotion/nokogiri/38721829c1df30e93bdfbc88095cc36838e497f3/patches/libxml2/0001-Revert-Do-not-URI-escape-in-server-side-includes.patch"
    sha256 "c755e6e17c02584bfbfc8889ffc652384b010c0bd71879d7ff121ca60a218fcd"
  end

  # Fix compatibility with Python 3.9
  # https://gitlab.gnome.org/GNOME/libxml2/-/issues/149
  patch do
    url "https://gitlab.gnome.org/nwellnhof/libxml2/-/commit/e4fb36841800038c289997432ca547c9bfef9db1.patch"
    sha256 "c3fa874b78d76b8de8afbbca9f83dc94e9a0da285eaf6ee1f6976ed4cd41e367"
  end

  def sdk_include
    on_macos do
      return MacOS.sdk_path/"usr/include"
    end
    on_linux do
      return HOMEBREW_PREFIX/"include"
    end
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
                            "includes_dir = ['#{include}', '#{sdk_include}',"
      system Formula["python@3.9"].opt_bin/"python3", "setup.py", "install", "--prefix=#{prefix}"
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
    args = %w[test.c -o test]
    args += shell_output("#{bin}/xml2-config --cflags --libs").split
    system ENV.cc, *args
    system "./test"

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import libxml2"
  end
end
