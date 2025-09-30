class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.10.tar.xz"
  sha256 "7ab7e2266808716e26c39924ace1fb46da86c17ef39d989624c42314b32b5a76"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "21289ec23a109fe9b676fc7de8d81687646d6b442a9dec2b8a6af8f718ce8b01"
    sha256 cellar: :any, arm64_sequoia: "5634f7dab4a1a1aae626e2bc5924a3737d0bcb837dcb4898e1fc826874cf835a"
    sha256 cellar: :any, arm64_sonoma:  "07b73759ecefe82efc737bcda354dccf5e2e456a2764c901e140205f682b1eec"
    sha256 cellar: :any, arm64_ventura: "1e17204482b03aafe1defd5a0523fd56c924afff6fd814bdfb6d03adc3d33efa"
    sha256 cellar: :any, sonoma:        "87c03521300deea80cdcde65cd5cafbb5d37973929b06882aa03e408e367bd46"
    sha256 cellar: :any, ventura:       "62493ad49029c723f04205ade288aef953f58b952ce6fccc95d55791e21ae0e7"
    sha256               arm64_linux:   "b97dd9a0f48a85b6f8c5aecae71d7bf07a39ec2d3228bdde8ea155a49c2b94ba"
    sha256               x86_64_linux:  "f955e7ece517c27b273e28ffeb1375f14142bccd51c0b6fcfebb6f3b0fcd09f9"
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
