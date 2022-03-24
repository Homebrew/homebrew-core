class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.6/gtkmm-4.6.0.tar.xz"
  sha256 "1353a09093cb571ef5ac05d93d200baf132ad604b5f4940777656e1505814c1f"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "545eb165acca93f629a8c81990e613a98bf5422bf13a1a375168d3e4d5edd438"
    sha256 cellar: :any, arm64_big_sur:  "e16ecff079d681f1368580dbe0efe61655afdc18c3eca50da1349f2688ef822e"
    sha256 cellar: :any, monterey:       "cbebe92ac8a5dd174e22ade3a4b2462572f7d86aedd9f6ed3e808743408b1c3c"
    sha256 cellar: :any, big_sur:        "be3236c68c6ff0c3d949b6c3bccd0abc78a622e7b860d7a3e559fcaed0616880"
    sha256 cellar: :any, catalina:       "344bd014f985af0e55bea9109ad1a43ce19c2509d2efc58a65795adb0d2eb354"
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
