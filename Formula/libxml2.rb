class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.10/libxml2-2.10.3.tar.xz"
  sha256 "5d2cc3d78bec3dbe212a9d7fa629ada25a7da928af432c93060ff5c17ee28a9c"
  license "MIT"

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4d52db64150b2622d00f6e20abf832242fd8b5d5a961862e3630f9c569b9dce4"
    sha256 cellar: :any,                 arm64_big_sur:  "b9fc6b15c854eab943397d48528b347490c73c85926c4453907d867e070217d5"
    sha256 cellar: :any,                 monterey:       "507dac0563ddf7ab56a04ed08d3c56e25ef136c4c0b8c966914460bc32f4f02d"
    sha256 cellar: :any,                 big_sur:        "762b8c4826709150f978f8592aa0f2f24852e5bd28c203bc27676db48fbdf4bf"
    sha256 cellar: :any,                 catalina:       "ccc6801ec07af49b1e28aa83f42d853913b5c61e635c45f0efcd51bdb146ee59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e8d9f1f22a9369801d55ff613fa23199825c4555134f4f2f12125a0a46ca295"
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
