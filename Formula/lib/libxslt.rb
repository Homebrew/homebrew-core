class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.40.tar.xz"
  sha256 "194715db023035f65fb566402f2ad2b5eab4c29d541f511305c40b29b1f48d13"
  license "X11"

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "45217af28930a18d480da9c30865bf4429603995694bed056a308faf1e91e826"
    sha256 cellar: :any,                 arm64_ventura:  "da5fee3fa7db7aae54b5dfa5573cb28ae4368e4ee9224195b1591b4a72bad6e6"
    sha256 cellar: :any,                 arm64_monterey: "84bb4c0eebc21ab238fa819ca3d2cbf9584237e958f97556e0bd63ccdfe548b5"
    sha256 cellar: :any,                 sonoma:         "377abf79c7f050b2c8454daf9e3f41b10a6440a0f85724ad07e222412e946b43"
    sha256 cellar: :any,                 ventura:        "222653f2ef69ac4690c083ff7e84fa293161c9e99f0bb9bdf8c91b5d423a5a2a"
    sha256 cellar: :any,                 monterey:       "683fe70bad7b86c8a4437ed9b4b7835ef8f8ba2f06542ccf3480a2567ef2f68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac38041572f80683578ade52e3439dd7f1dc911631ac60a31dc56bddc6a94d82"
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

  on_macos do
    depends_on "libgpg-error"
  end

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
