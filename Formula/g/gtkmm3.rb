class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.8.tar.xz"
  sha256 "d2940c64922e5b958554b23d4c41d1839ea9e43e0d2e5b3819cfb46824a098c4"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d09df4ca0f3ab0d81e6f6adf49fb8897e69f8d8782fe435fd941e1f8e67ce367"
    sha256 cellar: :any, arm64_monterey: "abc44666af25bedd6e470ed46dd54f6d8b9ce1e3e03c4020e335fa269e6f16e5"
    sha256 cellar: :any, arm64_big_sur:  "74547d4474ffdc944b017fa8394681b7ee669216ca1d3b0957d69c17968c99ca"
    sha256 cellar: :any, ventura:        "63fca66eadb4a64d3a4155e8671ec80dccc423150eeab5bb50534830eae4221d"
    sha256 cellar: :any, monterey:       "25d28cb65838bb115c07facd15450f69b16919fca544e97c2302cb51e1d33070"
    sha256 cellar: :any, big_sur:        "cc4a7601a18212b67b82c0b630a93d8bd95cd67cee936f2e8c93b612d7bbf12e"
    sha256               x86_64_linux:   "4636cb05f997adce9a64c56c745dcc553f0f2884d6a803cfd25371ab7dd6dfe2"
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
