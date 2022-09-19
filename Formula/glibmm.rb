class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.74/glibmm-2.74.0.tar.xz"
  sha256 "2b472696cbac79db8e405724118ec945219c5b9b18af63dc8cfb7f1d89b0f1fa"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "6a64c235fc6a9c86a5f63e2ed5f6bdff7ee7255879f0c67382884b4a41817066"
    sha256 cellar: :any, arm64_big_sur:  "f3c0131d708f404c29ac9b1a1b24766294f4d2616eae6e505b15af3234085b7f"
    sha256 cellar: :any, monterey:       "493b21bfbacd2922030467242906c47183e2849e98e3a7653f755d48f26faa67"
    sha256 cellar: :any, big_sur:        "fe7183b28b58884d27217d851e28d4fb89227204e4f50cf9b238fc03a103ac68"
    sha256 cellar: :any, catalina:       "e2bb1811d324f8bcb4fae160f834ae931770f6c7a14287c4ca9ca46bdab0f757"
    sha256               x86_64_linux:   "75e7999ade666972bbebaa8bf7a73ba9a8c2aa26187b1e9227b28ca9097fd5db"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++"

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
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.68
      -I#{libsigcxx.opt_include}/sigc++-3.0
      -I#{libsigcxx.opt_lib}/sigc++-3.0/include
      -I#{lib}/glibmm-2.68/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.68
      -lgobject-2.0
      -lsigc-3.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
