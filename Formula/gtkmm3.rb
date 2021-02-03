class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.3.tar.xz"
  sha256 "60497c4f7f354c3bd2557485f0254f8b7b4cf4bebc9fee0be26a77744eacd435"
  license "LGPL-2.1-or-later"
  revision 3

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3b532015fa27753a66beb7d3f3d878df3287854239a5a8dbe3e4d2d21925d39f"
    sha256 cellar: :any, big_sur:       "2a868d1c823f77a92609967b978d9507e0c53cc6975e13e74ab86f2cc7dc18a6"
    sha256 cellar: :any, catalina:      "4f38441a8e8ad604a828292b5ce994c342512151607cfd291e79794b9c9c4235"
    sha256 cellar: :any, mojave:        "36e3de79e24802c980b23b9136bc6291120fc693c2d1b766dfc2542d5abb97d8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "atkmm@2.28"
  depends_on "cairomm@1.14"
  depends_on "gtk+3"
  depends_on "pangomm@2.46"

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtkmm-3.0").strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
