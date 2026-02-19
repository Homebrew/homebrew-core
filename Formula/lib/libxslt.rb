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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5247978b2374fcb0d2a4f9b0ce74c08fde85305c2d2816b458e8a64fc7013c7d"
    sha256 cellar: :any,                 arm64_sequoia: "f1ba7468eded4f5db764b1a35802820af8be74455130443dce0748370b9d4e54"
    sha256 cellar: :any,                 arm64_sonoma:  "97e95a9b6f10e601120a14bb003b6bb4ca6248123368425ea6295cc36f40f4e3"
    sha256 cellar: :any,                 sonoma:        "75584f355ae00d06a7e5b1844e08acad55ea3a8d48db8425ef7f5066db590a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a08d60e1ea50a89702e83b5ac483104831961bb42d47684ba7f6f8bd3bbed98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b03c065c1b506ebe8caac9d6ad14b9d46950faad527e6ca89aafcd9eec234e5"
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

    inreplace [bin/"xslt-config", lib/"pkgconfig/libxslt.pc", lib/"pkgconfig/libexslt.pc"], prefix, opt_prefix
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
