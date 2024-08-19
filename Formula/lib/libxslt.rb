class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.42.tar.xz"
  sha256 "85ca62cac0d41fc77d3f6033da9df6fd73d20ea2fc18b0a3609ffb4110e1baeb"
  license "X11"

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3c3a336b56c8384b9c2956202cc78e28271db8b627a65227f77f049d387b8c05"
    sha256 cellar: :any,                 arm64_ventura:  "fd6b363128cde585e7086df6d54c8473475a568842b6aa04add1947dae8b9135"
    sha256 cellar: :any,                 arm64_monterey: "27c8a5e233ab19a82557b33c99f4e226610859832b27c18276a49c1a3765621d"
    sha256 cellar: :any,                 sonoma:         "33fbe4982e16be91957f9eeb77f35f70385831d479a15b87908389a1077a475c"
    sha256 cellar: :any,                 ventura:        "82e7425e4331d0024a053434efbd3e6035721a3f792b3fb5b8b8d72fce88cc73"
    sha256 cellar: :any,                 monterey:       "1609668b445f07134b3f6fafa6cc0307d0659466f2d4aa708e0787bf3a064a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222f19398d1b8f2d1efb196b2336d9b6a8b805abd6b3ab3f1d002112dc7fa67c"
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
