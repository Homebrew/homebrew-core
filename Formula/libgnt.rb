class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://keep.imfreedom.org/libgnt/libgnt"
  url "https://downloads.sourceforge.net/project/pidgin/libgnt/2.14.2/libgnt-2.14.2.tar.xz"
  sha256 "61cf74b14eef10868b2d892e975aa78614f094c8f4d30dfd1aaedf52e6120e75"
  license "GPL-2.0"

  livecheck do
    url "https://sourceforge.net/projects/pidgin/files/libgnt/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fb95e81366fa30eeba4c475a6ceb3a3b10e627f479dd5bc32b1d4ed55785a98a"
    sha256 cellar: :any, big_sur:       "8af4cf0b8e2727ad0db525084fa644d80df9d1c3fbbada9700a988a5c651dc39"
    sha256 cellar: :any, catalina:      "69c11afb2957571a907a82545da6ea8bed0f9d35193c9cc15d0e2063f82f976b"
    sha256 cellar: :any, mojave:        "d805104397225f4c57b8f5c5310f3c77f5eea4f5870332b15c84717c465fb384"
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
