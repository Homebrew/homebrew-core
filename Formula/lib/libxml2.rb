class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.11/libxml2-2.11.5.tar.xz"
  sha256 "3727b078c360ec69fa869de14bd6f75d7ee8d36987b071e6928d4720a28df3a6"
  license "MIT"
  revision 1

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8fd3dfc23275635bd786a3ef09749c909ac2bb2ea2e4b271ff82bd9f575d7215"
    sha256 cellar: :any,                 arm64_ventura:  "ecd502e0a296fa9ff0b093eec0d0ff537ee6750a11ca3475c3317bdfe032b5ec"
    sha256 cellar: :any,                 arm64_monterey: "77927824b8c8aaf89f77eeab57396835d1d33cc8d150c2e3ca86264dd4aef943"
    sha256 cellar: :any,                 sonoma:         "fd14314e2f93b55340e363ebb5fa52283871c9df33e7d04674fe84ee865cf4b0"
    sha256 cellar: :any,                 ventura:        "df22f461f6b5412d06d4e2dbf2802b59d09ebc2a599c112673e069c75e482757"
    sha256 cellar: :any,                 monterey:       "696c7526f3e6d052af2e8c9d8556b0c32dc840b76574480025ede87b1f5d9d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ceccd15fd3b58cb7be51a09879c6d31f58ddc300a74379f29823177975f280"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "pkg-config" => :test
  depends_on "icu4c"
  depends_on "readline"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
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

      pythons.each do |python|
        system python, "-m", "pip", "install", *std_pip_args, "."
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
    args = shell_output("#{bin}/xml2-config --cflags --libs").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Test build with pkg-config
    ENV.append "PKG_CONFIG_PATH", lib/"pkgconfig"
    args = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    pythons.each do |python|
      with_env(PYTHONPATH: prefix/Language::Python.site_packages(python)) do
        system python, "-c", "import libxml2"
      end
    end
  end
end
