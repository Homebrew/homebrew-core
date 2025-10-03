class FltkAT13 < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://github.com/fltk/fltk/releases/download/release-1.3.11/fltk-1.3.11-source.tar.bz2"
  sha256 "ca2e144e5f89173cd094cc273940d56230b1bf613083a0792e6406dc191cd99f"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(1\.3(?:\.\d+)*(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e5bfa45b6f629465158e069725e1a45f2de382b40158fdb98576b7c65ea462b5"
    sha256 arm64_sequoia: "f5b728f548ac5ac54af3dc19be243326a413c0111eb087fd0872f9bd1f258598"
    sha256 arm64_sonoma:  "d2cbe3e12f0c773764c686a4ae985ac60d5e6c1cade32777ae90f193cf102145"
    sha256 arm64_ventura: "43791ddf08bb27b33df7b5f1e72f79e0d833c02c2160aae579bed6b19314a6eb"
    sha256 sonoma:        "ae4c28c88a1d1b5df4f449ecb68656176de7a847ba9e8b5b04496a9fd2fd76a3"
    sha256 ventura:       "a08e62819ae086c72f22d35935324f1a6a4f74449008c78daa678bef112627f4"
    sha256 arm64_linux:   "91a9242d3b1865e00c589082e2e40204ba9e7a38ac048e8a91d61ceff61cf255"
    sha256 x86_64_linux:  "4ebdfda730ed6638cce196160c79146729505609e7c1a56b135d78dfb5235691"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  on_linux do
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = %w[
      --enable-threads
      --enable-shared
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
