class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.7.tar.xz"
  sha256 "1d7a35af9c5ceccacb244ee3c2deb9b245720d8510ac5c7e6f4b6f9947e6789c"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9c5913ee79cab986ee26accb6bf5ce09609f0680656086a7f6e00a54caa92659"
    sha256 cellar: :any, arm64_monterey: "808bfe18b6b0520ae339f1547226186e26d2921aec56a1a893e23d944a4c8526"
    sha256 cellar: :any, arm64_big_sur:  "27b6d3262145f8603093b58ca8acb18f2ab85e0a7c278e5b07cf6af9da8e6095"
    sha256 cellar: :any, ventura:        "0826ae1a46d4c9e3d26ca4cbcb00202f193e2ab7287bda7e2d0f4366b0f7bb75"
    sha256 cellar: :any, monterey:       "0d993ae9c31063d3e051809dc39e5c519f757488d0dc2329cd55088676d0ee89"
    sha256 cellar: :any, big_sur:        "d02cdf945b5d228921bd461fadffeb28e384e29166b4483760ee3be9f7ab2c9f"
    sha256 cellar: :any, catalina:       "c482ea55a5f8d0eace78b24ce5b8337b355f47816cc3c3b71f2767af2ed5bdb1"
    sha256               x86_64_linux:   "a13ec506b7a75317c847535caa40ab647b8ac562d306eee35a499030ab9594d2"
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
