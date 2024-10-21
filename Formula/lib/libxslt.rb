class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.42.tar.xz"
  sha256 "85ca62cac0d41fc77d3f6033da9df6fd73d20ea2fc18b0a3609ffb4110e1baeb"
  license "X11"
  revision 1

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e5743ac455f3135b1238d5bfc26860f5421093761b7c6974579d9db6dbd68d8"
    sha256 cellar: :any,                 arm64_sonoma:  "3027548c825b0f6715294f5ba996e580b09c6530d459788044a6a095cf789a24"
    sha256 cellar: :any,                 arm64_ventura: "ac34533e43ac19e2c259598ee0b233b7f75e66547423b7fe0a99f5b27be5c7fd"
    sha256 cellar: :any,                 sonoma:        "bd9313ff618b8a9a2c4b55948d3a57162017e1c01deb2cc7e2529814be41f904"
    sha256 cellar: :any,                 ventura:       "5ed5bfee0e7dbfc436885d85dd498beac016647ff997fe3da54ae3972899fdf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09861e3e118d40c2ab0eae14761182f95aa6c71600c5850bea1c0ee32afe0b1e"
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
