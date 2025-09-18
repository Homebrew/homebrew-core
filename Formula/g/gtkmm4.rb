class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  license "LGPL-2.1-or-later"
  revision 1

  stable do
    url "https://download.gnome.org/sources/gtkmm/4.18/gtkmm-4.18.0.tar.xz"
    sha256 "2ee31c15479fc4d8e958b03c8b5fbbc8e17bc122c2a2f544497b4e05619e33ec"

    # Fix build failure with Gtk4 >=4.20.0
    # https://gitlab.gnome.org/GNOME/gtkmm/-/commit/94959145f8b9248e7f6384fb293f1429599f614d
    # We can't use the upstream commit because it requires re-generating pre-generated files in the tarball.
    # This requires many extra dependencies (see the `head` spec) and fails on Linux for some reason.
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7fe103fa6db91d5ca0c22235119bfc6e234702b3c772ad52ae6354b55559be5c"
    sha256 cellar: :any, arm64_sequoia: "2c90560baeab5574799ad941c526f4bddea3a036ee50246a1fa20f115bc83706"
    sha256 cellar: :any, arm64_sonoma:  "4765665435e5ede864791e4515d61c82eefe4f0b4ecaab402b08e349d2e8db0f"
    sha256 cellar: :any, arm64_ventura: "3c376f06a9a0e79fd91d916f1acf3065570d4981759202f6ed239ef80e4b7c38"
    sha256 cellar: :any, sonoma:        "b429e64dc8909038b3b72fc1a317a1f7488ee132902cb690f00de01a6ada0395"
    sha256 cellar: :any, ventura:       "33fb1e507d12094ecd6e2bb2afa5b0bf34c52b8dc371102d1459db425bd05f28"
    sha256               arm64_linux:   "f8faf04812bab8c0d947808334bb0b6e866bdad9f4e9cceb621b30c96a230da7"
    sha256               x86_64_linux:  "0c4bb4079e03fd81994829459e64b3843121e95b86ab0f90b2242d287b2c50d2"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/gtkmm.git", branch: "master"

    depends_on "mm-common" => :build
    uses_from_macos "m4" => :build
    uses_from_macos "perl" => :build

    on_linux do
      depends_on "perl-xml-parser" => :build
    end
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "cairomm"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libsigc++"
  depends_on "pangomm"

  def install
    system "meson", "setup", "build", "-Dbuild-documentation=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <gtkmm.h>

      class MyLabel : public Gtk::Label {
        MyLabel(Glib::ustring text) : Gtk::Label(text) {}
      };
      int main(int argc, char *argv[]) {
        return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs gtkmm-4.0").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git i/untracked/gtk/gtkmm/iconpaintable.h w/untracked/gtk/gtkmm/iconpaintable.h
index dfdedf3..432ab1b 100644
--- i/untracked/gtk/gtkmm/iconpaintable.h
+++ w/untracked/gtk/gtkmm/iconpaintable.h
@@ -29,11 +29,10 @@
 #include <glibmm/object.h>
 #include <gdkmm/paintable.h>
 #include <giomm/file.h>
+#include <gtk/gtk.h>
 
 
 #ifndef DOXYGEN_SHOULD_SKIP_THIS
-using GtkIconPaintable = struct _GtkIconPaintable;
-using GtkIconPaintableClass = struct _GtkIconPaintableClass;
 #endif /* DOXYGEN_SHOULD_SKIP_THIS */
 
 
