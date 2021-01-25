class GlibmmAT264 < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.64/glibmm-2.64.5.tar.xz"
  sha256 "508fc86e2c9141198aa16c225b16fd6b911917c0d3817602652844d0973ea386"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.64/"
    strategy :page_match
    regex(/href=.*?glibmm[._-]v?(2\.64(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "59179b822c27f1c01e10ae59e44562dabc44f5f00f04c0951644f7d2465146eb" => :big_sur
    sha256 "411944557e76a827e1ece0e6a34f862ab30bdaaae2de37e0a4ce5338a3f33112" => :arm64_big_sur
    sha256 "d8e9d38b8a4a3945777ccacc703363e1c036efa1aa2b49ee857a08e7938f7c5e" => :catalina
    sha256 "838331b973d6d0498c16a28330e1354d63fa7dda297a32093eaf37660a0227c0" => :mojave
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
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
