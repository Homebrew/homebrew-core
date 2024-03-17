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
    sha256 cellar: :any, arm64_sonoma:   "fb81c07b62bf93741751146db60e01d13dd0f2e2f10686286703133e8356668a"
    sha256 cellar: :any, arm64_ventura:  "a96cef2e81067ac9239b8eeadd95f1e13f33f02058e43a6f2b349b56b5579c2c"
    sha256 cellar: :any, arm64_monterey: "417c16642451874e4444883262d2850241e35607d87e8bf02c534b041b798f3d"
    sha256 cellar: :any, sonoma:         "ddebda42ae26f02c468c9fa4d990ec4c6a110c281c90d63f4a6db1ab6eb53ba6"
    sha256 cellar: :any, ventura:        "94b66c7c5c18c00262020c88f2abed754cbf9e500f1838d2c9e634f99b91ea6b"
    sha256 cellar: :any, monterey:       "059230eadd967c816ea5c01903c5eb07c39690dbc9c54cdec0cbbcf5760c1a91"
    sha256               x86_64_linux:   "548ac36e8284ef35d9bb0700f63a50deb54ebfb67b27de3e72b0ab45793b6232"
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
