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
    sha256 arm64_ventura:  "88567f860b5e3ad354ad086b5f5fa19a2d088d867af42207ced931a30005b805"
    sha256 arm64_monterey: "977f25c376ffbf7785a8a3464e61490c40d7eb940385cae3b205ef9b9d53b693"
    sha256 arm64_big_sur:  "b304a9f2d24f97e179cb5731713fc4876a730b507eb057bba4f9097af46d7708"
    sha256 ventura:        "07d68504346b0d2529b01a14146f37e303fe3fa900c58667d51a30097abde11e"
    sha256 monterey:       "84df93d99e85fff484d42ab803a41ca83daec204950e2f2dc32602c718c646f5"
    sha256 big_sur:        "8ead5b96878ad431ac3e23dc3bd20bb4eac509c63c231e594986a0fa331e157f"
    sha256 catalina:       "3900f64476d7988670b5d0c855f072fba0af2b1bb323acf4f126f70c95a38616"
    sha256 mojave:         "10d1f2a81a115b9cf1e8c76fbd6cdc58f5b4593eb7f9e15cbe0127e14221dd06"
    sha256 x86_64_linux:   "aac750f0c7081619c9f3a403bfbc47ac58cd6300733b2d31dc2b0384b1500066"
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
