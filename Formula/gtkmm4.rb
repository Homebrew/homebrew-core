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
    sha256 cellar: :any, arm64_big_sur: "347734f4e95e5edcf93f2a69ddab693d66c2b0cc74880f5080ebef3cc2d1aabc"
    sha256 cellar: :any, big_sur:       "8f8dcb9eeced9ee633dbb9f5a7e6342b359596f95f7ba3e7f064f92ff91ea113"
    sha256 cellar: :any, catalina:      "d5108f300f4bc69d6f3e2cd79a7995761fb04c6a0829a023e4aaec886a6f4363"
    sha256 cellar: :any, mojave:        "1698ed19f44fe423e1c412104c55dcfd701403d773c7c9fbbd017064edb220b1"
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
