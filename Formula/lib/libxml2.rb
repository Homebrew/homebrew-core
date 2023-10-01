class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.11/libxml2-2.11.5.tar.xz"
  sha256 "3727b078c360ec69fa869de14bd6f75d7ee8d36987b071e6928d4720a28df3a6"
  license "MIT"

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d022fd63f93d9155d65bacdb6ae8322f0f77cd7a0dde5dff4dc58e2ce123b367"
    sha256                               arm64_ventura:  "13369bc7d99cf8b2da61d00010daa496b0cc4827b7dea969e83ff56d701535f1"
    sha256                               arm64_monterey: "a565a94492747550cac53e4a8988d5a5bdb235b42c78d41aa665e54c0af5a7ba"
    sha256                               arm64_big_sur:  "53d0a8877fa30effdaa962aa4931a19e9248f602f8f5af7b6e04a86a31ce31d0"
    sha256 cellar: :any,                 sonoma:         "6fb019b4a767c0ac26fd9a447c920f42d0e3583a0a8f77b4308f023a42e99649"
    sha256                               ventura:        "e7d54df72be1a1f7839a13aa938fc70375d05bb1b86f700dd742f212bafd44c5"
    sha256                               monterey:       "e3e9db1cf350fab27dacd482b85f99a99d6f86b5a071dd3531537d7cfeb954b7"
    sha256                               big_sur:        "7d1cb8b9058159135350b8746a53beb867f8ea8176e621b250f0434b6e9ca749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2c54074766d2ed5d369c168362558c9405ba8874cf1c8337b4f454c6f562be7"
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
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
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
        system python, *Language::Python.setup_install_args(prefix, python)
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
