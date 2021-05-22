class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.5.tar.xz"
  sha256 "856333de86689f6a81c123f2db15d85db9addc438bc3574c36f15736aeae22e6"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b89600d8d2301d3b440cb815e95063324fe1399272b35c5a725249fb0b44d72a"
    sha256 cellar: :any, big_sur:       "7081b730e353b703eda9599ecec61b47fbba3f95b19deef570ac439be153a52e"
    sha256 cellar: :any, catalina:      "8347d81d1189d3c8d4d4602aded86414588e0946fd92ead1cbe5377d2162c7b5"
    sha256 cellar: :any, mojave:        "ed39e4bc3f056d509905d3e9109c0c1051973fdda081c359e556ec0e0032dfbb"
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
