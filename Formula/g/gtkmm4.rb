class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.22/gtkmm-4.22.0.tar.xz"
  sha256 "2e8a21b4b0725f620e33aaee0cd343ed121b533275b632896619b1c89e96de67"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5019a6a838cfdb66402a58a076e55b75bba6047bb057d66c4b8394b750697656"
    sha256 cellar: :any, arm64_sequoia: "fd5b4a4af9452f8362b3a89d6276aaffad7e7bcf5ea60bb0a969bb26e6faddf7"
    sha256 cellar: :any, arm64_sonoma:  "c15e328c41f4c0b0fc58e3e8ccb397950bcd5f2f58168f1ea79630d73b961587"
    sha256 cellar: :any, sonoma:        "a9f3106a239e143f95d1266c27bd97c8fe4642834dfb4f00e2e9c6d402a73ff9"
    sha256               arm64_linux:   "ba6496171930003554fee4c2c985f5adab37e10a73bad7a3e744642fba694e55"
    sha256               x86_64_linux:  "75a94d1632ef8fd4bdec9853484f828d0717b67f12e558f7bcb9bca08766e755"
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
