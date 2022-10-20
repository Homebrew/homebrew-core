class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.8/gtkmm-4.8.0.tar.xz"
  sha256 "c82786d46e2b07346b6397ca7f1929d952f4922fa5c9db3dee08498b9a136cf5"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "dec88e65848253c7a4d434a2d2f8f203bd41815ca6b03caa19c40b38c9210a7c"
    sha256 cellar: :any, arm64_big_sur:  "9b85467c73912e156db432c26f8d65d20eb34d557849549e300ca7da48f47b61"
    sha256 cellar: :any, monterey:       "c9149bef97843c81b6f2345eecae097c88232164acfea98a09f63a7d4f283b29"
    sha256 cellar: :any, big_sur:        "2c7247708b823ce00462cf419513ba5cee394951f7a6db411a0654011bb68751"
    sha256 cellar: :any, catalina:       "8a1da65e7de51882a9815e05b20afc3a00c81e9dfff4a10d3c74f587ccc574bb"
    sha256               x86_64_linux:   "bbb9b2f21354e474597d8c4ac91af3ac1a86396b5e5d43a3259487f6aae9fe28"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairomm"
  depends_on "gtk4"
  depends_on "pangomm"

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
