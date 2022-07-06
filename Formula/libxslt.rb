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
    sha256 cellar: :any,                 arm64_monterey: "d4e838d39e46b3127daa3de7ba8568f6205e4cf012ce68895858be7ac1637088"
    sha256 cellar: :any,                 arm64_big_sur:  "71a8b03956e0ea4a101a275d241557d90558f864a8ee45b8fb34c7cece0b9afa"
    sha256 cellar: :any,                 monterey:       "3efcae3bffc789ac4de6ed201b77055244958ae41269fa8195a1e72441cffa0b"
    sha256 cellar: :any,                 big_sur:        "8f29731b31ff245754421368e92586955501b9630ae07de3fb5541e32bb9af2c"
    sha256 cellar: :any,                 catalina:       "341e68ccde02547177a2e9bcb23ed3cbb5559e7d9c8ab6bff5dcf3397c20898e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43e979ab0c9bde23c378e7901b316e5048833e1231b4d0f879094bdf1253cf70"
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
