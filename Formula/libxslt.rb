class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.38.tar.xz"
  sha256 "1f32450425819a09acaff2ab7a5a7f8a2ec7956e505d7beeb45e843d0e1ecab1"
  license "X11"

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d865d7bc0e0aded29f5d64d0ee62cca485971ab659758c4cb13414dc67f4a57"
    sha256 cellar: :any,                 arm64_monterey: "40e875895ea4ad049d0b3112f9df9176fc3b21b1686f117fa327586c7c78e3e3"
    sha256 cellar: :any,                 arm64_big_sur:  "ea8f6e2449b1be6bc30ec7322b762933ef2c57634579fc02442a2dc170e68d0f"
    sha256 cellar: :any,                 ventura:        "861855483278b668cfb905c7a54140ba602aaa765f98e6bf9c7bc2bd5d6e7a1e"
    sha256 cellar: :any,                 monterey:       "74207471f760ee5b2fd3a9ec293f729a226a712c056d4a263634ffde01f0dfd8"
    sha256 cellar: :any,                 big_sur:        "3af50421f2fb62f33e3d49be4f78757164c81838c7c83f28eadf3b3123c25948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de9ab6fc29079326654cbf1b0bb8119f4dcf717b5418bf8c65ea1346b3f09b3"
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
