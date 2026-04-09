class Gtkx < Formula
  desc "GUI toolkit"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.33.tar.xz"
  sha256 "ac2ac757f5942d318a311a54b0c80b5ef295f299c2a73c632f6bfb1ff49cc6da"
  license "LGPL-2.0-or-later"
  revision 2

  # From https://blog.gtk.org/2020/12/16/gtk-4-0/:
  # "It does mean, however, that GTK 2 has reached the end of its life.
  # We will do one final 2.x release in the coming days, and we encourage
  # everybody to port their GTK 2 applications to GTK 3 or 4."
  #
  # TODO: Deprecate and remove livecheck once `gtk+` has no active dependents
  livecheck do
    skip "GTK 2 was declared end of life in 2020-12"
  end

  bottle do
    sha256 arm64_tahoe:    "50bf4d48f706e87bc7bff60b97ea41bc0ca1d4616390be8fe2781360531244c2"
    sha256 arm64_sequoia:  "a431feb1110a7b24050d4115bf8a0701eefb6ea735c276acc99c23a9260f72e8"
    sha256 arm64_sonoma:   "659b62a2677b7e945221ab78abfab6919d7a4ac7c635de52417ab96eb4970a92"
    sha256 arm64_ventura:  "140729098a62031c80b8e43c29314f84a5d0152b1348612f83d01331251ba02c"
    sha256 arm64_monterey: "88b226c05abe1a848ee8ab7d98e7b0388383b3cdd003dff8448aa9d1901202c3"
    sha256 sonoma:         "2f73f9eafd45eef1e37f3e795d1cb086988fcba1cc374be9c4bc124744bc561a"
    sha256 ventura:        "e1724dfbff3e12dfc41c91d4ea850c52fbc716d30cae80308f55afaeaa887e42"
    sha256 monterey:       "29944de5a2598f393c086c1b9284dee31f94309826780204065d91de38c0a14d"
    sha256 arm64_linux:    "2738367a37a58ce253544f191877c5b653c3f6db7cbe3fd5ed3b3288b3bd243f"
    sha256 x86_64_linux:   "a73d8262778cf3541249d2ce04dbe9c2e545cc46401c695a77a893f812f35920"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "hicolor-icon-theme"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxcomposite"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxrender"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Patch to allow Eiffel Studio to run in Cocoa / non-X11 mode, as well as Freeciv's freeciv-gtk2 client
  # See:
  # - https://gitlab.gnome.org/GNOME/gtk/-/issues/580
  # referenced from
  # - https://bugzilla.gnome.org/show_bug.cgi?id=757187
  # referenced from
  # - https://bugzilla.gnome.org/show_bug.cgi?id=557780
  # - Homebrew/homebrew-games#278
  patch do
    url "https://gitlab.gnome.org/GNOME/gtk/uploads/2a194d81de8e8346a81816870264b3bf/gdkimage.patch"
    sha256 "ce5adf1a019ac7ed2a999efb65cfadeae50f5de8663638c7f765f8764aa7d931"
  end

  def backend
    backend = "quartz"
    on_linux do
      backend = "x11"
    end
    backend
  end

  def install
    # Uses obsolete CGWindowListCreateImage. GTK+ is EOL so won't be updated to ScreenCaptureKit
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "14.0" if OS.mac? && MacOS.version >= :sequoia

    # Work-around for build issue with Xcode 15.3
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types -Wno-implicit-int"
    end

    system "./configure", "--disable-silent-rules",
                          "--enable-static",
                          "--disable-glibtest",
                          "--enable-introspection=yes",
                          "--with-gdktarget=#{backend}",
                          "--disable-visibility",
                          *std_configure_args
    system "make", "install"

    inreplace bin/"gtk-builder-convert", %r{^#!/usr/bin/env python$}, "#!/usr/bin/python"

    # Prevent a conflict between this and `gtk+3`
    libexec.install bin/"gtk-update-icon-cache"
    bin.install_symlink libexec/"gtk-update-icon-cache" => "gtk2-update-icon-cache"
  end

  def caveats
    <<~EOS
      To avoid a conflict with `gtk+3` formula, `gtk-update-icon-cache` is installed at
        #{opt_libexec}/gtk-update-icon-cache
      A versioned symlink `gtk2-update-icon-cache` is linked for convenience.
    EOS
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        GtkWidget *label = gtk_label_new("Hello World!");
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs gtk+-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
