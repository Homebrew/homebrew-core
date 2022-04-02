class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.6/gtkmm-4.6.1.tar.xz"
  sha256 "0d5efeca9ec64fdd530bb8226c6310ac99549b3dd9604d6e367639791af3d1e0"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d0a29a1b6856c7e1b43254ab5648d8cee10fc118e893b774e91bbf1e64c7fc62"
    sha256 cellar: :any, arm64_big_sur:  "63206963d3f5e963e1ea9478a52615bae880ce196f8ca47c30bde6e821adb0ee"
    sha256 cellar: :any, monterey:       "ce1bdb42ba696680e8950eb8bbc7b2fe3f4adc16cbf69f54ce543729234b2ca3"
    sha256 cellar: :any, big_sur:        "8fe3a6122f0e7669953da0bf617095cf062ede423ce9eec112b5bfe5e59ca6c4"
    sha256 cellar: :any, catalina:       "fbb4f9ecf8b3b16d7c56cf7a9e056b80884e3db21389f27710fc4ffb5898845c"
    sha256               x86_64_linux:   "7ad7516dfea72e57da04c003e66294bea0b262dbe7ee695fb506aa9ffb4d83c7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairomm"
  depends_on "gtk4"
  depends_on "pangomm"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
