class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.39.tar.xz"
  sha256 "2a20ad621148339b0759c4d4e96719362dee64c9a096dbba625ba053846349f0"
  license "X11"

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28019195eef786264be3a0e67f814753a9108653c5f9e07964b89502c66b06e9"
    sha256 cellar: :any,                 arm64_ventura:  "9921d7bd84d8fc6914244d5142fb60741eabc71a9a3af87b3c04967f9d334aba"
    sha256 cellar: :any,                 arm64_monterey: "c48449d1ad89ada8cf9133ea7ea88b247730144ea874dff9608eae0a7b89b882"
    sha256 cellar: :any,                 sonoma:         "9a4458989d734defc29a7c042b1144a0a66c3768530fb0e07fe52ea78828e606"
    sha256 cellar: :any,                 ventura:        "695cb26667ee927b4f20fae395b48b8af4bf666f3dc9625bef2e3823aa2e65d8"
    sha256 cellar: :any,                 monterey:       "ed196bcf4372dacf751a8ba6d45feac8aa6220a877828785651c4694e6209f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e671ea1b060a25b0db9ab3486ae21b1da5982b6e4a35593a411e9c6d103544"
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
