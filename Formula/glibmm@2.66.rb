class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.5.tar.xz"
  sha256 "7b384662dd6ec3b86c0570331d32af05db2bd99a791602b767b4a0b2566ec149"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    strategy :page_match
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "2ffccba88c59692e588626434bc1657e50fb19883305ef1e3c2007cb577c2d7b"
    sha256 cellar: :any, arm64_monterey: "05c14e78a13a1664c202444e90570e8d47ec3ef078d8ef09496e2fd053d4b649"
    sha256 cellar: :any, arm64_big_sur:  "56b410adec1bde766b38a0ddf0d23be7521b5d7563b26c4311d4ce594ee132ee"
    sha256 cellar: :any, ventura:        "1389e91603686af3a1a85759b584013f57369e4b42cd95919e0e9956a8316f18"
    sha256 cellar: :any, monterey:       "50ad009e59740399ed6fc83a2037fa233cf9aad126bfdeb088cd56da56e6aa21"
    sha256 cellar: :any, big_sur:        "188a58d8e551ea3c5903f0d4a30d15fe89b34ecc9ed1fcdbc25f8997f1ebecf9"
    sha256 cellar: :any, catalina:       "d0a79fbae0da97c9c7f3f3e92be18cbccdff1a8fd16266f2f4fa4941a34124ed"
    sha256               x86_64_linux:   "1219c3527ea4f63907facaa202a8719ce6b03c5aba6add906290a6607f2a32ae"
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
