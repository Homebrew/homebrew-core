class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.43.tar.xz"
  sha256 "5a3d6b383ca5afc235b171118e90f5ff6aa27e9fea3303065231a6d403f0183a"
  license "X11"

  # We use a common regex because libxslt doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "882f9071165800a694e3dc146e614c984b70d80cf8fa284cc78dd0f35f096a2f"
    sha256 cellar: :any,                 arm64_sonoma:  "ba204e6736fe30b763bc9372a464f050daa8c5d66aebbff6c8659abbc796d4ae"
    sha256 cellar: :any,                 arm64_ventura: "68fbcc1a39a1af56dda4c550816f0a4796ed8b70608518b184331f1e13a1ff1b"
    sha256 cellar: :any,                 sonoma:        "c2432ea083f92c5d6ffd4968f7a0e3d675f7c2098f27e2742b607a9ba68d1f6d"
    sha256 cellar: :any,                 ventura:       "96311a902a7c1ce991bfb90a01b11442d5ede675238afd8ed22980f7d91b415f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "847d260b760e00468ab47ce7b72514ef3381622fdb396512926ef4c82d54d1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "595b354dd8c9dc086224701709d5a471f7a916693ebf52e5d68eea1f454bd98d"
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
    depends_on "pkgconf" => :build
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
