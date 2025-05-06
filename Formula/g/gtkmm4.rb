class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.18/gtkmm-4.18.0.tar.xz"
  sha256 "2ee31c15479fc4d8e958b03c8b5fbbc8e17bc122c2a2f544497b4e05619e33ec"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "45f72e4079b03119f5aa4d27bb7b2004dfd8e44a980fe550098a93c86248e959"
    sha256 cellar: :any, arm64_sonoma:  "4577ada6c92b8eedda931d73c2820a65308c5863f2ff4d8eaf0fd96cee6f0a1f"
    sha256 cellar: :any, arm64_ventura: "043d75d67b710a15990b48bc2e76cea7a45b3f3ca28a7f91242c710ea06a65c7"
    sha256 cellar: :any, sonoma:        "0ee8fe1d4addd3c071228a3c148b24e1dd0e6b307face59ca9dfd00ceeff5a4d"
    sha256 cellar: :any, ventura:       "af5a7c6f8fbbb6069fb4cc9bdbd11e78e072f43e5f391896924c01bf19c3ab50"
    sha256               arm64_linux:   "b6d3373334c215ec185f7e17c90f1f50798d12c37934a6f7cabf54c619a4c484"
    sha256               x86_64_linux:  "e6406579298ce93e310bcdea9fb9b7d9a201ccf3446f65d04259c7988f0d68c2"
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
    system "meson", "setup", "build", *std_meson_args
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
