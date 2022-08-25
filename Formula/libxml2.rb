class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  license "MIT"

  stable do
    url "https://download.gnome.org/sources/libxml2/2.10/libxml2-2.10.1.tar.xz"
    sha256 "21a9e13cc7c4717a6c36268d0924f92c3f67a1ece6b7ff9d588958a6db9fb9d8"

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
    sha256 cellar: :any,                 arm64_monterey: "ee4191450d7a4bc3b945d60e937aaeba118b7a2febbcb362ece80af986f6d3bd"
    sha256 cellar: :any,                 arm64_big_sur:  "97ab504e79ae3671460e7663d157b85e74e022d003387760a8ca026fead4e525"
    sha256 cellar: :any,                 monterey:       "aade7642cb495560c63626f4abf643674e0c80c3967d1df3510fcbefb3ca30ce"
    sha256 cellar: :any,                 big_sur:        "6727fe671a52e128542553db45531f6c5763e2a25af394bb1925f86dfc8138c1"
    sha256 cellar: :any,                 catalina:       "4d36ec6b11f34847fd6d23323610c68965856de999a8f150dd043f480ad8ec8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb066a12fb1493d3c5288d337c411e3e7a3472c54159c5e1f9a0b0f03746b496"
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
