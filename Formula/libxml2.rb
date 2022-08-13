class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  license "MIT"
  revision 3

  stable do
    url "https://download.gnome.org/sources/libxml2/2.9/libxml2-2.9.14.tar.xz"
    sha256 "60d74a257d1ccec0475e749cba2f21559e48139efba6ff28224357c7c798dfee"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end

    # Don't require ICU headers when using libxml2's public headers.
    # Remove with 2.10 or later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/a248d94d777c70f440d07032956a13c8158b7f0a/libxml2/2.9-icu-headers.diff"
      sha256 "4b139cf66913fbeb60e9beef8872060c7a533d974b5a46ec81b85234a75a1430"
    end
  end

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "196b1d9de0be78fc90e33dfa61dcb43ed060f7ff0c001c13cc9faaa86e3a0098"
    sha256 cellar: :any,                 arm64_big_sur:  "8863dc376bf4150fa1f889b4a355940eed94e4122ebaa97653b560b9b770d324"
    sha256 cellar: :any,                 monterey:       "56fef01e0a6a25e5691234709e6fb759479c5afe8421cf0ce523311cdca26753"
    sha256 cellar: :any,                 big_sur:        "98209f8e14bad338ac1ee9d122be856165f233b5c87ed2178b21f1b583b2a2eb"
    sha256 cellar: :any,                 catalina:       "f9a4269a4317bdfde65c28277e1599fc0c62ceff29f8ce3b9ff3fb33f6d9818c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f2f9d3ec1c992a8f508b28ab2d132b97cfef9d5b2d73de2227b8188446e4333"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python@3.10" => [:build, :test]
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

    cd "python" do
      sdk_include = if OS.mac?
        sdk = MacOS.sdk_path_if_needed
        sdk/"usr/include" if sdk
      else
        HOMEBREW_PREFIX/"include"
      end

      includes = [include, sdk_include].compact.map do |inc|
        "'#{inc}',"
      end.join(" ")

      # We need to insert our include dir first
      inreplace "setup.py", "includes_dir = [",
                            "includes_dir = [#{includes}"

      ["3.9", "3.10"].each do |xy|
        system "python#{xy}", *Language::Python.setup_install_args(prefix, "python#{xy}")
      end
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

    orig_pypath = ENV["PYTHONPATH"]
    ["3.9", "3.10"].each do |xy|
      ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
      system Formula["python@#{xy}"].opt_bin/"python#{xy}", "-c", "import libxml2"
      ENV["PYTHONPATH"] = orig_pypath
    end
  end
end
