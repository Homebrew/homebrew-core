class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.43.tar.xz"
  sha256 "5a3d6b383ca5afc235b171118e90f5ff6aa27e9fea3303065231a6d403f0183a"
  license "X11"
  revision 1

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00b783860da281f1b95ee86dd4ef1ed3698dc536aa47411eaf61afe743ee39c7"
    sha256 cellar: :any,                 arm64_sequoia: "9c117a774fea99f9d64f774657ba53a9effd590b8b3d32e0bcb7300a8a25a514"
    sha256 cellar: :any,                 arm64_sonoma:  "ff471277f7d68ae3ade59b2daca57eb9df1010cea35a237452ba7cd16a032126"
    sha256 cellar: :any,                 sonoma:        "0879b5648c5ed2d32161c2c132e4d5d7a936799df7dfabe2ff38308a99cdbd00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "638280d9d9e16ae3b441270efa406c2dc8a72c6ec17f3b7fa76743e852e384b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ca37765a78544525ae61e5d466e5d777c03b8320ee02b73629055b18782f4c"
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
