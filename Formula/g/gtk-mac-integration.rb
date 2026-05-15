class GtkMacIntegration < Formula
  desc "Integrates GTK macOS applications with the Mac desktop"
  homepage "https://www.gtk.org/docs/installations/macos"
  url "https://download.gnome.org/sources/gtk-mac-integration/3.0/gtk-mac-integration-3.0.2.tar.xz"
  sha256 "42f29e002365467eac10f4ba78435d4be785a947424d9890112c8c8d5e21be25"
  license "LGPL-2.1-only"

  # We use a common regex because gtk-mac-integration doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-mac-integration[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ee2a0dd43946f07ac42ef0acad00a96aa5075890029f32272a139d5d1fa07f0e"
    sha256 arm64_sequoia: "7ca343892d71cdb55caf11b1998168507845c155857f0064b5e5847352a8a233"
    sha256 arm64_sonoma:  "cf8e1ad3215498c4682d30479c1850a89e1fcf478d9b69004da3dd7105afff75"
    sha256 arm64_ventura: "03dbfce85532960db4084577e2e3ad7d7b6f82975dc3edaf3d96435a83a79526"
    sha256 sonoma:        "ce981b3727a5b425b31d44a918d2a44bb49c159214b0e13bd5968c1c653438d1"
    sha256 ventura:       "38d4c1f561c9062c4a6cbd38e282c42ae7fd7a07612c3f3417038c101a3cc715"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/gtk-mac-integration.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on :macos
  depends_on "pango"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"

    system configure, "--disable-silent-rules",
                      "--without-gtk2",
                      "--with-gtk3",
                      "--enable-introspection=yes",
                      "--enable-python=no",
                      *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtkosxapplication.h>

      int main(int argc, char *argv[]) {
        gchar *bundle = gtkosx_application_get_bundle_path();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs gtk-mac-integration-gtk3").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
