class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  license "X11"
  revision 1

  stable do
    url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.35.tar.xz"
    sha256 "8247f33e9a872c6ac859aa45018bc4c4d00b97e2feac9eebc10c93ce1f34dd79"

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
    sha256 cellar: :any,                 arm64_monterey: "644a233f90ece4bebe3d6b28622790cf9d7b62a24ad368d255fa56b206b9da3d"
    sha256 cellar: :any,                 arm64_big_sur:  "1f0562826221dc40fa094317bf3e5af12b6ce06607ac0eefb7b8e9cd50126e47"
    sha256 cellar: :any,                 monterey:       "446288bd1f77ae39357105b241d416f09cf8195eec907439058d7e210295f75b"
    sha256 cellar: :any,                 big_sur:        "dae6af266515bc09a8d5acf87729a6592faf1ea08878e171e0ca4577744a4288"
    sha256 cellar: :any,                 catalina:       "7491c8a98678e9c0fd2569bfbf1f332b62e44292ab85c873583e2b418bdfe459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f360705ba83a03270e94556d8d76e6ca1200a0ed2bd8a9e27bc1d4d98bdab0d6"
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
