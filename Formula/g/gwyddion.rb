class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "http://gwyddion.net/"
  url "https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.68/gwyddion-2.68.tar.xz"
  sha256 "725c3f71738362b10b1e2cf76d391684cf2f15a71a2b34ef1caddabd6d5a9bfa"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://gwyddion.net/download.php"
    regex(/stable version Gwyddion v?(\d+(?:\.\d+)+):/i)
  end

  bottle do
    sha256 arm64_sonoma:  "b43e730eff6442bc243f8ac823d66f9662ddb19d3b45ba2fd4839539633ceec1"
    sha256 arm64_ventura: "102134d0cc82e99b16f10beca65fbff50cf90fc20e8dfb9109947f38397c6e27"
    sha256 sonoma:        "2a46d8ac980a10cff9a5dd4e6ad6676732f36f3683e3f15527e73cbd2fbc00fe"
    sha256 ventura:       "98f80d6914545e03d705f8b36386f25c40c24b28790c68b3cd960f57736777e0"
    sha256 arm64_linux:   "50c3c92bfa90b717cd0363f1848160dd2f09460cf7c9bc2bac377dc773c976cc"
    sha256 x86_64_linux:  "ddb58bb61054c7d019aa1db4b8da4378829026a723bcd40d3181382e2809f562"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "fftw"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "gtkglext"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "minizip"
  depends_on "pango"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    # Regenerate autoconf files to avoid flat namespace in library
    # (autoreconf runs gtkdocize, provided by gtk-doc)
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    # TODO: depends_on "gtk-mac-integration"
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", "--disable-desktop-file-update",
                          "--disable-pygwy",
                          "--disable-silent-rules",
                          "--with-html-dir=#{doc}",
                          "--without-gtksourceview",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gwyddion", "--version"
    (testpath/"test.c").write <<~C
      #include <libgwyddion/gwyddion.h>

      int main(int argc, char *argv[]) {
        const gchar *string = gwy_version_string();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gwyddion").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
