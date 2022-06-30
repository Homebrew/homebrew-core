class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.10/libxml2-2.10.2.tar.xz"
  sha256 "d240abe6da9c65cb1900dd9bf3a3501ccf88b3c2a1cb98317d03f272dda5b265"
  license "MIT"
  revision 1

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "760f0fa4f7265098a3e63f1800d84195b8980b6adc154868aec5bfa79464689b"
    sha256 cellar: :any,                 arm64_big_sur:  "885f66f44b7d0b4b35f373a721912b99aba2acfd6df34cb0fefd92bf745c1308"
    sha256 cellar: :any,                 monterey:       "73d69e20cc975fced791ed8c6d99c03b92a0574c4cacbfeebc8679bf8cc12eac"
    sha256 cellar: :any,                 big_sur:        "2c6a92e86e895ffe2b5ec6702e6bafff469f1bfafd9fae0856173e554155fb41"
    sha256 cellar: :any,                 catalina:       "a8911d24caa63ac8a6149e08751f7e168992d88fb6b05f1077ca51433a64f2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8be6671348b6216226b970a8196e7fe0c74342fadb8e3bb595ee851fdeb731d"
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
