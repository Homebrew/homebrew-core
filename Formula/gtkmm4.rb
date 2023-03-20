class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.10/gtkmm-4.10.0.tar.xz"
  sha256 "e1b109771557ecc53cba915a80b6ede827ffdbd0049c62fdf8bd7fa79afcc6eb"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "7ccb484b0df2e4d2270d35d404751166e4b0917ca8a43547242f587e38b99b00"
    sha256 cellar: :any, arm64_monterey: "e75513422db9413b7cbf3f7d659bcd6160c66137aa15cf41275a62c7620ee748"
    sha256 cellar: :any, arm64_big_sur:  "a873f2bbad0c599bb71965061532b610955b5762dd3cb8e81c3526a6eeddac60"
    sha256 cellar: :any, ventura:        "2ae876886e55d5fcf9de15273ff58c14091934855f0e232cba307de9c7adc253"
    sha256 cellar: :any, monterey:       "7f60d3e02f3a575d53b3a35cef959812ba8829bb93cd4c41b634e78110534cc8"
    sha256 cellar: :any, big_sur:        "cd1cdf2bec5e69eb42ccdb8878ffa2b8c6fb7d97dddf54122d193aa33ddc40c6"
    sha256               x86_64_linux:   "fdbed5da4ff3aab516a19c6d5ff82c3ca415c6be62cf153f2dcceac0105026da"
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
