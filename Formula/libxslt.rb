class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  license "X11"

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
    sha256 cellar: :any,                 arm64_monterey: "95ee37540095f14e19fee092aa0a53d2e634de071c6165f90a996dc4b05121f2"
    sha256 cellar: :any,                 arm64_big_sur:  "ec2551bbb89b9544e80586680db51270ccabf53be680b31178a7eb4b7a1fc6d9"
    sha256 cellar: :any,                 monterey:       "b07661a0aa21e453d2f58cafdc7425bdd0270459def4e7354f3147bcbeeaaad7"
    sha256 cellar: :any,                 big_sur:        "2ce7c3f7bbb1ffd73028662afca32211205734c5676ac743e865d9da2426bb5b"
    sha256 cellar: :any,                 catalina:       "9afef3e030939882119df041160dbb00437c726101c7047e310abad7c354b2e9"
    sha256 cellar: :any,                 mojave:         "a60cb3dba137da40ece1d48ed404adaa62c7a61e5be8618a03a035ac3413f03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4644ffb9534613738889d7bf32b204c2e257a6a5154ab8e80209709a4a6f4f3f"
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
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-crypto",
                          "--with-libxml-prefix=#{Formula["libxml2"].opt_prefix}"
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
