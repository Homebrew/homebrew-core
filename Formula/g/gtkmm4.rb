class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.20/gtkmm-4.20.0.tar.xz"
  sha256 "daad9bf9b70f90975f91781fc7a656c923a91374261f576c883cd3aebd59c833"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "75f595a7d74ebe4f7fb3d531be9ce70cc70e6b77194d0c6984907da14497d1fd"
    sha256 cellar: :any, arm64_sequoia: "fac1c12fd0d8e2ae213e1ac9957a1bacbe662e466144769df805c966b0322f89"
    sha256 cellar: :any, arm64_sonoma:  "af3d4f4127d457bdef6639c83ac0c850e41d236ffd3a33e4ac0f3aaa53672ab0"
    sha256 cellar: :any, sonoma:        "54c7c7e6a00276d3b9f21c144b8a2c3cc359f5cd2c073b6c5b51b82d4d48bb46"
    sha256               arm64_linux:   "0077f613e776d7d5e27c23082c73cd2405a27534b025708443cf4e69979c2e29"
    sha256               x86_64_linux:  "3ea11d6e9eeb9634d885d182615693f80b81c890d650233dbb8f20e298f141e0"
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
