class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.4.tar.xz"
  sha256 "65d042e1c8010243e617efb02afda20b85c2160acdbfbcb5b26b80cec6515650"
  license "MIT"
  revision 1

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e55be8b308a20960064eda65e61bf119ed063c016c3af3fc512b78a2a7902105"
    sha256 cellar: :any,                 arm64_sonoma:  "c7723baf8bb27b7207c095099fb98a4e35262922ad0984e4d43e7f8aa1c2ffa0"
    sha256 cellar: :any,                 arm64_ventura: "022e585d660f17306b4a6aa38ef5c3eef5bcb91fc1911c47e4c5311fc726508d"
    sha256 cellar: :any,                 sonoma:        "5db978e999a8f3ab0f72380f37318620dec63c9a52b01d49bed01e9a78de3cc2"
    sha256 cellar: :any,                 ventura:       "0f8e4bb206959e34c7b96afe45e504bc6c4ee8e076253f04487c0c239a19e8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56efca78252ed7c800f31bb97afc41db3fc5eb4f626de440769c1f846d3e7a98"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "pkg-config" => :test
  depends_on "icu4c@75"
  depends_on "readline"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # Work around build failure due to icu4c 75+ adding -std=c11 to installed
    # files when built without manually setting "-std=" in CFLAGS. This causes
    # issues on Linux for `libxml2` as `addrinfo` needs GNU extensions.
    # nanohttp.c:1019:42: error: invalid use of undefined type 'struct addrinfo'
    ENV.append "CFLAGS", "-std=gnu11" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--disable-silent-rules",
                          "--with-history",
                          "--with-http",
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

      # Needed for Python 3.12+.
      # https://github.com/Homebrew/homebrew-core/pull/154551#issuecomment-1820102786
      with_env(PYTHONPATH: buildpath/"python") do
        pythons.each do |python|
          build_isolation = Language::Python.major_minor_version(python) >= "3.12"
          system python, "-m", "pip", "install", *std_pip_args(build_isolation:), "."
        end
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
