class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.6.tar.xz"
  sha256 "4b3e142e944e1633bba008900605c341a93cfd755a7fa2a00b05d041341f11d6"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "08878aa200b82ccee7bc89768e654cfe34a3a55263f3df99053aaff412049f04"
    sha256 cellar: :any, arm64_big_sur:  "d5c58a535248b69441ce00ca49096a0f1c87181b240a07683a027d6a4f2cc6e4"
    sha256 cellar: :any, monterey:       "d6f001c1678fe11d2dba345e5a7c722a4812c3bb2d0f3be7f18618b3419b1c70"
    sha256 cellar: :any, big_sur:        "5b81b6a7924269dd1d1e09813fb2f4d5c18bca18a70fc416bf1741b3a065b553"
    sha256 cellar: :any, catalina:       "c0145e5fa5437418cd8f6d7977c73dd8aef5d40b4cd32294988c5b1603aef798"
    sha256               x86_64_linux:   "ee319bc686e418e930a644969f8ce57fb14b911d83e561f2ac16c9d3b3624532"
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
