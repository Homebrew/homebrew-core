class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.0/gtkmm-4.0.0.tar.xz"
  sha256 "3105adb76b738e4af5c0be7b1915f8e39de15474fcfdced9f5a59a2d9b52f83e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "ef80d29cee5c8dc89f1c67286578a5ba4184c89f25e812156dc635a9949ba92f" => :big_sur
    sha256 "a9bd6430e6fd3907379e5d920d133c6cae97e138347b484f287905d00710837c" => :arm64_big_sur
    sha256 "167c1777a12807a3d6beb77c8eea5a2905402d3eb80f4e1a1799ac2284ac34f3" => :catalina
    sha256 "9d9efaba8f60440d68c910bb2a4770fa41f7872e1cef3579c3491c2f5194c1fb" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairomm"
  depends_on "gtk4"
  depends_on "pangomm"

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
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtkmm-4.0").strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
