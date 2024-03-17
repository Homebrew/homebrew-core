class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.9.tar.xz"
  sha256 "30d5bfe404571ce566a8e938c8bac17576420eb508f1e257837da63f14ad44ce"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "de79dca06f3dfb036716b7a160060046906ea5150d40ca7b159220476ecfa4e0"
    sha256 cellar: :any, arm64_ventura:  "7787e5acc82a86d6fecfb5dbdcf11a5017d55195eb316b11149c6572de21ee3f"
    sha256 cellar: :any, arm64_monterey: "b0da6596d666382192cc05dd198e409fae3a1e1982c6678d85059c8190a598f0"
    sha256 cellar: :any, sonoma:         "20d3111ea94300f070dc542a98207ed731beab610992a4935c595028841c556c"
    sha256 cellar: :any, ventura:        "0d964d3a69ca598dc342c0f89e6e5506819b72f2ca13225ce8d17a9beaedf10c"
    sha256 cellar: :any, monterey:       "1e2d63f0b7dd2441e3fdc12feb40fa746274c014fb9b56b9394f4acc02d5365f"
    sha256               x86_64_linux:   "7542428aad76723deac89d2872af1788ecfa8206d80a8486ef860b22b7ed829b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "atkmm@2.28"
  depends_on "cairomm@1.14"
  depends_on "gtk+3"
  depends_on "pangomm@2.46"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
