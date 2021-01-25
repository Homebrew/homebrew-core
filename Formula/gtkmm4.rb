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
    rebuild 1
    sha256 "a6cb635d097c0a9efc7715a2d6d73af7513b3ae03f88afb69377042902a31b09" => :big_sur
    sha256 "5393bb27125814b587b43c3bf448c4df9bf4423445135927fe050969297665fb" => :arm64_big_sur
    sha256 "eb185bc75e8189fbb6e5c3a6008931436d03bcb1cfe77f0b95088b4468dd3ba6" => :catalina
    sha256 "1df902710183ad22fe01dc9f665f8730704e4aeffd2d5e694c84a56d56d0faa9" => :mojave
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
