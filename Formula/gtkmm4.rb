class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.8/gtkmm-4.8.0.tar.xz"
  sha256 "c82786d46e2b07346b6397ca7f1929d952f4922fa5c9db3dee08498b9a136cf5"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "dbf58821c35c29c300c5a7bf3d491fe58daad89c774a6f5baf912c444069711d"
    sha256 cellar: :any, arm64_big_sur:  "2aa04470fed6f8c64bd99d86707e8cf1d24b4af634d1e89f659745f741e32787"
    sha256 cellar: :any, monterey:       "043b608ff6526c179fb5098376721a9994f4ea9ee8ca8aab02b97753488ce46c"
    sha256 cellar: :any, big_sur:        "822f03220be22e20d53e796ecadefcddef34bca6d717b0e6963d3ba03cb41fb7"
    sha256 cellar: :any, catalina:       "8d8c6c2197f35dcf5634df9fd2cd4c1e0b84acd4e8dedefb06facc881cfe670c"
    sha256               x86_64_linux:   "ae7deafebe370f0c6765d6e78315fcf9b7ee4fa18d03ef3f33b6795edf3c24b1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairomm"
  depends_on "gtk4"
  depends_on "pangomm"

  fails_with gcc: "5"

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
