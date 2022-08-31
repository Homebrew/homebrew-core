class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  license "X11"

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
    sha256 cellar: :any,                 arm64_monterey: "ff42fbff107accee3da9596f78f8d4f8a38dd51d3f897ddb08becd473bdedab3"
    sha256 cellar: :any,                 arm64_big_sur:  "802097422ba65866e3073d899a1e66c6a863da97d9be5cac5fd23f0b24cbed60"
    sha256 cellar: :any,                 monterey:       "4bf10f5022be3d0b12be95f348ffb24ef3ae287e466746f1cd0968c5f90d5b0d"
    sha256 cellar: :any,                 big_sur:        "2d00f21a1d2950509823d7da7d2fd9bddbef382300ff105c0d4c27bbf53a7292"
    sha256 cellar: :any,                 catalina:       "b910166d05f747a02b7110573ea3c75cb7d5ce4a9e7afcdb4be6e1a9cf5d260e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48cf979b62117c684da43b6d2ca063a772447e2448172212e6f219a83d0b4c04"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

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
