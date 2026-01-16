class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.45.tar.xz"
  sha256 "9acfe68419c4d06a45c550321b3212762d92f41465062ca4ea19e632ee5d216e"
  license "X11"

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f84bd522d90559af9d166263695c0bdfb1dd99523b99c25a908f5dfeff0d2823"
    sha256 cellar: :any,                 arm64_sequoia: "c6c94bfff23f4c1bd122badc497e6c5f9c0d3cbb764507bd75d30a680fe3ee67"
    sha256 cellar: :any,                 arm64_sonoma:  "52285c023c4a4b8854cf02c732e29f87895b654ccf03d2f124ec51775dcdadc2"
    sha256 cellar: :any,                 sonoma:        "97488beb7b0f8b4e85f82374abe0bc8b251c110ec12e2133251acef583e647d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f92807009e5459c8402a6aa16b487ac01c753841eb37540ca80677979e31cc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1682448b43ec04a0f79ee77fc8cc6bf65c04a279e5879d2ca19c894d27943c5"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "libgcrypt"
  depends_on "libxml2"

  on_macos do
    depends_on "libgpg-error"
  end

  def install
    libxml2 = Formula["libxml2"]
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--without-python",
                          "--with-crypto",
                          "--with-libxml-prefix=#{libxml2.opt_prefix}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To allow the nokogiri gem to link against this libxslt run:
        gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
    (testpath/"test.c").write <<~C
      #include <libexslt/exslt.h>
      int main(int argc, char *argv[]) {
        exsltCryptoRegister();
        return 0;
      }
    C
    flags = shell_output("#{bin}/xslt-config --cflags --libs").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-lexslt"
    system "./test"
  end
end
