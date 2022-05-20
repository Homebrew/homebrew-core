class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.72/glibmm-2.72.1.tar.xz"
  sha256 "2a7649a28ab5dc53ac4dabb76c9f61599fbc628923ab6a7dd74bf675d9155cd8"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "c29aa04bc62b03add040f49af1002fdde20d9b4e5eb2cc4f96422cc937fce3c1"
    sha256 cellar: :any, arm64_big_sur:  "58bfdbea84d605f3fa8ba7825b71e2f9ae6c7bf091fff97c8444a8b31adf54dd"
    sha256 cellar: :any, monterey:       "c5772c2c3e829d36be16c89a05bb65e429f1558c2b3abe21172749574861220a"
    sha256 cellar: :any, big_sur:        "aec0ad08f5deb73b234ef8d9ea60889db68429a2e6b037c812aa3b417c9cfcea"
    sha256 cellar: :any, catalina:       "bfe5a02b9bd0517cb6f58feccd502538a2f4eae548b27509d9bd323ac5502d1e"
    sha256               x86_64_linux:   "f14a1f30131ecb144ec9d8e615e360573074eb482e03987e0aa2435544ee617a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++"

  on_linux do
    depends_on "gcc" => :build
  end

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
