class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.2/gtkmm-4.2.0.tar.xz"
  sha256 "480c4c38f2e7ffcf58f56bb4b4d612f3f0cac9fd5908fd2cd8249fe10592a98b"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "8678fd72c6111120f7b5ea4bdf0a55940a34aa52aec23e724b7d0ad2719095ee"
    sha256 cellar: :any, arm64_big_sur:  "88cc51b5d7ff82f704b0fd4a1b53d6932ee5aeb3d5319c70226080a502ad7bf9"
    sha256 cellar: :any, monterey:       "fb4d1543767a9513992776d3bcb15d74faa121edafc16616ec166395e60fa980"
    sha256 cellar: :any, big_sur:        "ac0d436909b6be289508ff5aac82d6ab59c36f144145b7259b77234e2b544116"
    sha256 cellar: :any, catalina:       "6a67aa2c9ae11a5dea8c142f221a0b6fdaece0f6ceecfd9747aeda99782cea21"
    sha256 cellar: :any, mojave:         "5f21219575cf773cb21686b592cdf8e05617567490111a7919b87dc5d165fb63"
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
