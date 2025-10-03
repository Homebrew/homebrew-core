class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.15.0%20Source/plplot-5.15.0.tar.gz"
  sha256 "b92de4d8f626a9b20c84fc94f4f6a9976edd76e33fb1eae44f6804bdcc628c7b"
  # The `:cannot_represent` is for lib/csa/* which is similar to BSD-Source-Code
  # license but is not an exact match due to phrasing. It refers to "materials"
  # rather than "software" and clause 2 does not mention contributor names
  license all_of: ["LGPL-2.0-or-later", "BSD-3-Clause", "HPND", :cannot_represent]
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "8299e82b21073d81694f33383bc0dd37931cfc8f468be9107b8c7b8fcd1cf501"
    sha256 arm64_sequoia: "9305edca28268f6aed4efa7da578545c70d5feec4c2161da9f0e60aca9d3ace0"
    sha256 arm64_sonoma:  "bdc0cc407dee50cc18fe7b6b37db420f9331acb5b63b534931337fa151bf1d95"
    sha256 arm64_ventura: "93efe317d3c6e9e265061402aec9a37c332d15420261e47faa3a5c3f06a4aa02"
    sha256 sonoma:        "fe49328f9a4c77b4ef5890371504401147804bb4254525186f1f85a651a740e0"
    sha256 ventura:       "32fde8a89d5580c4e09d9fac911a5ac0c5ee2c745a967109e1c130600c30fce7"
    sha256 arm64_linux:   "3d07131a9d21a41cc2e5ffcb258312724f3c474220e5d9a0baa8abdfea2c6013"
    sha256 x86_64_linux:  "91ae9fc5f0d6d1ba8d8bb494bee3304655c35a7c8fa224baad1b9427a3ca3848"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "glib"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    # These example files end up with references to the Homebrew build
    # shims unless we tweak them:
    inreplace "examples/c/Makefile.examples.in", "@CC@", ENV.cc
    inreplace "examples/c++/Makefile.examples.in", "@CXX@", ENV.cxx

    args = %w[
      -DPL_HAVE_QHULL=OFF
      -DENABLE_ada=OFF
      -DENABLE_d=OFF
      -DENABLE_octave=OFF
      -DENABLE_qt=OFF
      -DENABLE_lua=OFF
      -DENABLE_tk=OFF
      -DENABLE_python=OFF
      -DENABLE_tcl=OFF
      -DPLD_xcairo=OFF
      -DPLD_wxwidgets=OFF
      -DENABLE_wxwidgets=OFF
      -DENABLE_DYNDRIVERS=OFF
      -DENABLE_java=OFF
      -DPLD_xwin=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_libdir: lib)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <plplot.h>
      int main(int argc, char *argv[]) {
        plparseopts(&argc, argv, PL_PARSE_FULL);
        plsdev("extcairo");
        plinit();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/plplot", "-L#{lib}",
                   "-lcsirocsa", "-lm", "-lplplot", "-lqsastime"
    system "./test"
  end
end
