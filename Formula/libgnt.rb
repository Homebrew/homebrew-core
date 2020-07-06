class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://keep.imfreedom.org/libgnt/libgnt"
  url "https://downloads.sourceforge.net/project/pidgin/libgnt/2.14.0/libgnt-2.14.0.tar.xz"
  sha256 "6b7ea2030c9755ad9756ab4b1d3396dccaef4a712eccce34d3990042bb4b3abf"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "0ddf1b6ebd64e3989ee3e2c1482d3f852a3f44f6c196586d1d9c4e839927087a" => :catalina
    sha256 "3d0291b16678836908fddc885fa613512e6f3ffbb2d11241a5320dfd48086822" => :mojave
    sha256 "0b710c423d8895b711d3f658fa6abdffe2b351c2256a429f49363eece64b8928" => :high_sierra
  end

  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gnt/gnt.h>

      int main() {
          gnt_init();
          gnt_quit();

          return 0;
      }
    EOS

    flags = [
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
      "-I#{include}",
      "-L#{lib}",
      "-L#{Formula["glib"].opt_lib}",
      "-lgnt",
      "-lglib-2.0",
    ]
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
