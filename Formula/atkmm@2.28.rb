class AtkmmAT228 < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.28/atkmm-2.28.3.tar.xz"
  sha256 "7c2088b486a909be8da2b18304e56c5f90884d1343c8da7367ea5cd3258b9969"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/atkmm-(2\.28(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "27e688d6ee177a411294848acda3aa39ced89fc8a9a12dc3822f3d42131e2673"
    sha256 cellar: :any, arm64_monterey: "876683a0c5f4da334dadb0142c564fb2007d9a3a66c7696dbfdc03dfb9162f9f"
    sha256 cellar: :any, arm64_big_sur:  "1b957048c912011d829c1b4842c8e7cb94526e80500046d732010881d33109ec"
    sha256 cellar: :any, ventura:        "82b1072bb49372eb831a548c33461d13db549f5856019cb2f86705e589726715"
    sha256 cellar: :any, monterey:       "8ca4c71ef66437838731e95a460d66430554fd3468b3c8856e638b09d94f2bc5"
    sha256 cellar: :any, big_sur:        "473ce70bed27eac91868d6b8214c027b08e88abea444076d20615462842b86a2"
    sha256 cellar: :any, catalina:       "4d2aeadd4d5114932d7d90ac2d53ed409e84b1703112e6dc5a0e8a5992d214b2"
    sha256               x86_64_linux:   "0b1ed87427fb65199370db6a27c2bb18c0ebf330782ff32297bf1519c74d764d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glibmm@2.66"

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
      #include <atkmm/init.h>

      int main(int argc, char *argv[])
      {
         Atk::init();
         return 0;
      }
    EOS
    atk = Formula["atk"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm@2.66"]
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/atkmm-1.6
      -I#{lib}/atkmm-1.6/include
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -L#{atk.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -latk-1.0
      -latkmm-1.6
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
