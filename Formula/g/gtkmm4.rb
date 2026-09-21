class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.24/gtkmm-4.24.0.tar.xz"
  sha256 "7fd9cea356e7d3b74bf7d2a51d7e0e6763f3f9f1cddc5e77c8b0b5b7fa9d5e5a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "842cd6a2ab287b029f18c493d663c909f0db8c6c77c58575cc2f9919d5321f36"
    sha256 cellar: :any, arm64_tahoe:       "25d09172c0222520d662c50f9ef212084b5aad4a9ddf6a96cc8f45527552e179"
    sha256 cellar: :any, arm64_sequoia:     "8f11a6f9b562287f1190bdf5698c4e0545f1cc020f8c92364e3a86bd2f421c38"
    sha256 cellar: :any, arm64_linux:       "a4c9e45c8e91c1f9394abaafa23f90a9d76cb6f1006b38e0e3e80c469e34ee18"
    sha256 cellar: :any, x86_64_linux:      "5621947bac3a749a61832a72fca3b1a244d542b345f0b69d87acf765adc38c67"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/gtkmm.git", branch: "master"

    depends_on "mm-common" => :build
    uses_from_macos "m4" => :build
    uses_from_macos "perl" => :build

    on_linux do
      depends_on "perl-xml-parser" => :build
    end
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "cairomm"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libsigc++"
  depends_on "pangomm"

  def install
    system "meson", "setup", "build", "-Dbuild-documentation=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <gtkmm.h>

      class MyLabel : public Gtk::Label {
        MyLabel(Glib::ustring text) : Gtk::Label(text) {}
      };
      int main(int argc, char *argv[]) {
        return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs gtkmm-4.0").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
