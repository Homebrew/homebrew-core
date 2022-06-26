class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.2.tar.xz"
  sha256 "b2a4cd7b9ae987794cbb5a1becc10cecb65182b9bb841868625d6bbb123edb1d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    strategy :page_match
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "5131ab5c66e574bb30d696dc0a078eef37c3fbbdbbd4962a1f8fec468e1774a3"
    sha256 cellar: :any, arm64_big_sur:  "239fdbfe8fb891068c1d62e67c9cd047af78997d722b4d315c336e4355d95e25"
    sha256 cellar: :any, monterey:       "f253fabbcde2fe8419b4892b2d89b065af94c86ee9214801392734e7aef6d26d"
    sha256 cellar: :any, big_sur:        "b9f2b7cb1cc2332b1ee4790dc8477a7df86ecafcd8d40ba459f3131007148a28"
    sha256 cellar: :any, catalina:       "782035c5298608b93ed10bcb526e5e68425ca030b4d34c79a55ddda0e33c2ae9"
    sha256 cellar: :any, mojave:         "0295dd5e75ea0ed118702663a113a5651094d7aabafa6773ecc877dded162258"
    sha256               x86_64_linux:   "e4f4d2271a4f469f779e3e3a39b877adf5d294bc176fee19c55efafc007174e4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++@2"

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
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
