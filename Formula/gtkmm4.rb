class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.0/gtkmm-4.0.1.tar.xz"
  sha256 "8973d9bc7848e02cb2051e05f3ee3a4baffe2feb4af4a5487f0e3132eec03884"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7e7d3e54eacf6a13fdb2f9d6ee99ec13f9a6bd3d2c76d43743c9d585c557a09b"
    sha256 cellar: :any, big_sur:       "0e4aa5b50896971c7567c5ef8eb395c06e41c25129bc227cdb845443bdac6d2b"
    sha256 cellar: :any, catalina:      "89097bb4e438265d5069fc57d3ab212049ace024cd17e7df6c4729261039f79b"
    sha256 cellar: :any, mojave:        "ea5386ba38bbc0538300b3bafd567580d9d4c17afe83c80ac3a304f0fa1e367b"
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
