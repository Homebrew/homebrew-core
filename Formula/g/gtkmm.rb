class Gtkmm < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz"
  sha256 "0680a53b7bf90b4e4bf444d1d89e6df41c777e0bacc96e9c09fc4dd2f5fe6b72"
  license "LGPL-2.1-or-later"
  revision 9

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9dd2dd1231eb90fe70da1f8961d9bd08e3e4f471ecba0cab542e6e30afc3cdcb"
    sha256 cellar: :any,                 arm64_sequoia:  "f41c412495a1c1d336076a5fc85f4499ae4c0cb2ef25b67ec8f2474cdca0f8a0"
    sha256 cellar: :any,                 arm64_sonoma:   "600f066eb0843c1af59bce66aa578afde52aa3a5754c42ed7b04445db839f837"
    sha256 cellar: :any,                 arm64_ventura:  "d664e40ad1a7d3e5dbb9dc05cb36d73f97e5bc4ab71747bf1b08c7d73abeae02"
    sha256 cellar: :any,                 arm64_monterey: "08400aebd2786edc67d2d6118dd98ea5e3e44ab3269f6fc49a651c7bc29589c3"
    sha256 cellar: :any,                 sonoma:         "c4aeb2114cd8dc59900af9d10e65c026ff69f3ede03c18dbc1ea655f9f3fc612"
    sha256 cellar: :any,                 ventura:        "992c80fea122b473d7788fe6733423dc729282fcce37095b204d5363e08b701a"
    sha256 cellar: :any,                 monterey:       "dde66554a67d936733736fd0c92a372ea01f7fad3ff3407cd2ce516c1332de13"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1ee8da8d884f6e6ef96f4088af2c27ed79d4d8067e527e3c57abd540006e9403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b8ee9aae96d13469d2ca251d59582d5577122d69769f9038e62b1792c08c861"
  end

  depends_on "pkgconf" => [:build, :test]

  depends_on "atkmm@2.28"
  depends_on "cairomm@1.14"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gtk+"
  depends_on "libsigc++@2"
  depends_on "pangomm@2.46"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    ENV.cxx11
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <gtkmm.h>

      int main(int argc, char *argv[]) {
        Gtk::Label label("Hello World!");
        return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs gtkmm-2.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
