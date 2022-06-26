class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  license "MIT"
  revision 2

  stable do
    url "https://download.gnome.org/sources/libxml2/2.9/libxml2-2.9.14.tar.xz"
    sha256 "60d74a257d1ccec0475e749cba2f21559e48139efba6ff28224357c7c798dfee"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "10f2630faa3eb5d1840210bf461ef2ec00f30bf84e7732bf8f7793177336878d"
    sha256 cellar: :any,                 arm64_big_sur:  "1121cf5f532c4a7e8e01173d78fb13b9f2afbec433c49a691df47f86508c6e0f"
    sha256 cellar: :any,                 monterey:       "9ef0a3cefa07728a1b4b08db180de0f1aba8a827e9e58fe4549fbd68dfbbb3e2"
    sha256 cellar: :any,                 big_sur:        "023456bec0dc12b1ea765a2ed4bd9d67117dad4ba14e0dfd21bc1cc598b8943f"
    sha256 cellar: :any,                 catalina:       "573f91a92d66c022482b943b258e4d883ff75ec9aa9c32df6a3203aec3003b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e83b54acd9f5967af5f7a7bafbf963c69942a7fd6a615dd45c32e153675b63e"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python@3.9" => [:build, :test]
  depends_on "pkg-config" => :test
  depends_on "icu4c"
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

  def install
    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-history",
                          "--with-icu",
                          "--without-python",
                          "--without-lzma"
    system "make", "install"

    # Homebrew-specific workaround to add include path for `icu4c` because
    # it is in a different directory than `libxml2`.
    inreplace [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"],
              "-I${includedir}/libxml2 ",
              "-I${includedir}/libxml2 -I#{Formula["icu4c"].opt_include}"

    cd "python" do
      sdk_include = OS.mac? ? MacOS.sdk_path_if_needed/"usr/include" : HOMEBREW_PREFIX/"include"
      # We need to insert our include dir first
      inreplace "setup.py", "includes_dir = [",
                            "includes_dir = ['#{include}', '#{sdk_include}',"
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
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

    # Test build with xml2-config
    args = %w[test.c -o test]
    args += shell_output("#{bin}/xml2-config --cflags --libs").split
    system ENV.cc, *args
    system "./test"

    # Test build with pkg-config
    ENV.append "PKG_CONFIG_PATH", lib/"pkgconfig"
    args = %w[test.c -o test]
    args += shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml-2.0").split
    system ENV.cc, *args
    system "./test"

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import libxml2"
  end
end
