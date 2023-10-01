class Gtkx < Formula
  desc "GUI toolkit"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.33.tar.xz"
  sha256 "ac2ac757f5942d318a311a54b0c80b5ef295f299c2a73c632f6bfb1ff49cc6da"
  license "LGPL-2.0-or-later"
  revision 1

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
    sha256 arm64_sonoma:   "88471bad07da1e18a8abbbbcb0cb418471298459098729505ea248ae9453207c"
    sha256 arm64_ventura:  "09d870f69784624a4585fd4778d622441689350d4ef444f658e5e8be0edb644c"
    sha256 arm64_monterey: "9c86b442ae42c6842b04c5f2fba9014cf92da4ce1b6730821d400b1549fb9c4c"
    sha256 arm64_big_sur:  "7f1fa14922a06171f2827daa56e7973721de2257a7920e8091081fedb641d63b"
    sha256 sonoma:         "f2e00cee20e14f8a3f3cf5df3ed23865f9ec50e6a6a5f407339e240915fbb9d7"
    sha256 ventura:        "336771ce80cf6413d18c87666abf8ff030faf96a8530c1f5e4185184d80d791b"
    sha256 monterey:       "b9e663b0c11f3fbd74d92aacf6246202b600dc4346de26f43516d1531d88b60b"
    sha256 big_sur:        "3eb689a0bf93bff2991160daa62cd31bea4ee77791ae216f2d6b30d5305ce6b4"
    sha256 x86_64_linux:   "3ccb9319c9550fd10cedb09ef7cfc51ed8ffd71b1698aa66d143d83f5c1b895a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "hicolor-icon-theme"
  depends_on "pango"

  on_linux do
    depends_on "cairo"
    depends_on "libxcomposite"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxfixes"
    depends_on "libxinerama"
    depends_on "libxrandr"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
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
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-static",
                          "--disable-glibtest",
                          "--enable-introspection=yes",
                          "--with-gdktarget=#{backend}",
                          "--disable-visibility"
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
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        GtkWidget *label = gtk_label_new("Hello World!");
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gtk+-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
