class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  license "X11"
  revision 1

  stable do
    url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.37.tar.xz"
    sha256 "3a4b27dc8027ccd6146725950336f1ec520928f320f144eb5fa7990ae6123ab4"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84d157e4ce52a4d6ce6bbb956b52fc12828751cd18f90a78e8e42cfbfe7cfcb0"
    sha256 cellar: :any,                 arm64_monterey: "3bdcf15cac29f738ea1d07b8e9c290a3a4eaf6c16ce3fefd13808be4556b9951"
    sha256 cellar: :any,                 arm64_big_sur:  "3ee16dc014079c7a03d5bb3ad4b10fff9942847d518b742f843c0fe0129de631"
    sha256 cellar: :any,                 ventura:        "018b6ed4a1eeea41daac97b7b732f4bf7b122ef070684a758025e316e753f00b"
    sha256 cellar: :any,                 monterey:       "c34db451bd574830c369e5dcab31e54e3474e5a31f83cb10b3650d85f149794a"
    sha256 cellar: :any,                 big_sur:        "378e59a2c69b0e06da3acd27bffc44b3906eb60d7ce3f4dd88287257a0ca0ef7"
    sha256 cellar: :any,                 catalina:       "3da3f7f87b9ff6bb7ce4eb67e810504dfbba998d3d537e11830047f248d8f69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65cb6fdd515408f8b95f3cc751a629add6c2410aa89e394b356a4e3bea26fa0c"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "icu4c"
  depends_on "libgcrypt"
  depends_on "libxml2"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    libxml2 = Formula["libxml2"]
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-crypto",
                          "--with-libxml-prefix=#{libxml2.opt_prefix}"
    system "make"
    system "make", "install"
    inreplace [bin/"xslt-config", lib/"xsltConf.sh"], libxml2.prefix.realpath, libxml2.opt_prefix
  end

  def caveats
    <<~EOS
      To allow the nokogiri gem to link against this libxslt run:
        gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
    (testpath/"test.c").write <<~EOS
      #include <libexslt/exslt.h>
      int main(int argc, char *argv[]) {
        exsltCryptoRegister();
        return 0;
      }
    EOS
    flags = shell_output("#{bin}/xslt-config --cflags --libs").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-lexslt"
    system "./test"
  end
end
