class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz"
  sha256 "c008bac08fd5c7b4a87f7b8a71f283fa581d80d80ff8d2efd3b26224c39bc54c"
  license "MIT"
  revision 1

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9e3cde9378a4638dc046655cc428e2fbf4cd2ec2991337fae3e57a9f065ef0e6"
    sha256 cellar: :any,                 arm64_sequoia: "d0656869714b8c590f9c980b08860c7245834a2679310ac7d411b1b9366593b1"
    sha256 cellar: :any,                 arm64_sonoma:  "ce27f215780fe6f227d0e24571d84d781c6ad52d8537d2ad6a1b5d404753c09a"
    sha256 cellar: :any,                 sonoma:        "833e98eaf14e628e1b3d3a7389be56eed7c476c807a60d43ff3fda3f972ebe18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f7f1f4c905b53efa09671d5a784742909ed0d108ccc8573ba32397cbec461b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3845c8e494648b4acecd10d54117f661a22fc637ac2b1c5e106d67caaa0939ba"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => [:build, :test]
  depends_on "readline"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--with-history",
                          "--with-legacy", # https://gitlab.gnome.org/GNOME/libxml2/-/issues/751#note_2157870
                          *std_configure_args
    system "make", "install"

    inreplace [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"], prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libxml/tree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    C

    # Test build with xml2-config
    args = shell_output("#{bin}/xml2-config --cflags --libs").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Test build with pkg-config
    ENV.append "PKG_CONFIG_PATH", lib/"pkgconfig"
    args = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Make sure cellar paths are not baked into these files.
    [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"].each do |file|
      refute_match HOMEBREW_CELLAR.to_s, file.read
    end
  end
end
