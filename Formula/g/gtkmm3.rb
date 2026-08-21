class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.11.tar.xz"
  sha256 "19e383c82d5dd89db275e00b82864e90414d4c3fb3d100b2f996bcc2338a4cc7"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "905cac7c972a40176e82731e271635fd1faafcc4680de4564c8d73b07815fdf1"
    sha256 cellar: :any, arm64_sequoia: "45654ffc54119805e7bc6e70daa7c3738ddf662851b175efd55d7c135da5c149"
    sha256 cellar: :any, arm64_sonoma:  "c8ef3f27e94eb1149e15ffdce35077800154473bdc725569f9f71f2ce68fdefb"
    sha256 cellar: :any, sonoma:        "e14a40611ed115c41493ef865d609f771e675508ab6faeda9f1e980d7dfd4fd0"
    sha256               arm64_linux:   "dac10871ec0e268aa7bce477ce0e3a83f124cc91b5c43fc9a783e9d425125fcf"
    sha256               x86_64_linux:  "ff91fabaafca241941eaf0128b085523d6ad279e31a07bb407eb96d608c52f39"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "atkmm@2.28"
  depends_on "cairomm@1.14"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gtk+3"
  depends_on "libsigc++@2"
  depends_on "pangomm@2.46"

  def install
    system "meson", "setup", "build", *std_meson_args
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

    flags = shell_output("pkgconf --cflags --libs gtkmm-3.0").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
