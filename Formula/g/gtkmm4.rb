class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.16/gtkmm-4.16.0.tar.xz"
  sha256 "3b23fd3abf8fb223b00e9983b6010af2db80e38c89ab6994b8b6230aa85d60f9"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "bd3991a723f1108bbe0cf033506a3918f15f1b7da5e7791470da2f45eeb572fc"
    sha256 cellar: :any, arm64_sonoma:   "d92d243a596afaa4fab46c97b1fa9a89c086dbcdfadf39e14fc5898aece8a98f"
    sha256 cellar: :any, arm64_ventura:  "e3a57fe48dbfd939d9e44878544fb3c83a1572ab75e4d6601f8b4e9568134bb6"
    sha256 cellar: :any, arm64_monterey: "ec886eb0fdc1180aa44208b97cd9ebb82e6d695636769405b856202bd9a5b6dd"
    sha256 cellar: :any, sonoma:         "39e1872ac9508ec896fbe3ea8b218fe1da4c267b4e59854c97712052bb64a4d1"
    sha256 cellar: :any, ventura:        "b97aecb02be2d10378973c2fadf863c5fb317fe6ec00a1eda6b724c696330c78"
    sha256 cellar: :any, monterey:       "3dbe629e2111f32747c953a323c2370037176c8f2da3f5a1814bdce7bcf4f41a"
    sha256               x86_64_linux:   "25be1257147ef191213595efd59df59a5cd72d4dd5645e5305d2a82901e7a6d2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "cairo"
  depends_on "cairomm"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libsigc++"
  depends_on "pangomm"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtkmm.h>

      class MyLabel : public Gtk::Label {
        MyLabel(Glib::ustring text) : Gtk::Label(text) {}
      };
      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs gtkmm-4.0").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
