class Libformfactor < Formula
  desc "C++ library for the efficient computation of scattering form factors"
  homepage "https://jugit.fz-juelich.de/mlz/libformfactor"
  url "https://jugit.fz-juelich.de/mlz/libformfactor/-/archive/v0.3.2/libformfactor-v0.3.2.tar.bz2"
  sha256 "b5cdb57fcbde6b39e314d7a040466a863f25625f112057e6d369a9ea5049dc1f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb97d04d8d908e6c984e441f0a24356b1ce5693041245d48cdf06ef77e7ce28a"
    sha256 cellar: :any,                 arm64_sonoma:  "06e3adc03557c8b8111e7c23406cfcbac96b2a8037aa35d1e5f5c7525bf44bab"
    sha256 cellar: :any,                 arm64_ventura: "20e9a3db52b38f4e8645bd4a3af04e05b1ffd06115e038bf66f7ae8cfb23d6be"
    sha256 cellar: :any,                 sonoma:        "c6b8de734ab738d9d954932e1c717c530435806fe98ebe7b51914ba70751ab99"
    sha256 cellar: :any,                 ventura:       "f77a4e09e46d58072891abb9a8a24ffb3b699b7468f0c51052f1b1e6c218ec52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb7155f05e1a721fd97a1136e91a7c136d98e92f3ab363f02e8f12c627727766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f902e487db84a1d1dd8a8c2e29c4ffcecd6a635d3c2404515ecefe7f1402c5"
  end

  depends_on "cmake" => :build
  depends_on "libheinz"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLibHeinz_DIR=#{Formula["libheinz"].opt_prefix}/cmake",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"fftest.cpp").write <<~CPP
      #include <ff/Face.h>
      #include <ff/Prism.h>
      #include <ff/Polyhedron.h>
      #include <cmath>  // abs

      bool CHECK_NEAR(const double value, const double expected, const double tol)
      {
        return std::abs(value - expected) <= tol;
      }

      bool test_asPolyhedron_prism()
      {
        ff::Prism prism(false, 1, {{-0.5, -0.5, 0}, {-0.5, 0.5, 0}, {0.5, 0.5, 0}, {0.5, -0.5, 0}});
        ff::Polyhedron* polyhedron = prism.asPolyhedron();

        const bool test0 = (polyhedron->faces().size() == 6);
        const bool test1 = CHECK_NEAR(polyhedron->vertices()[4].z(), 0.5, 1E-13);
        const bool test2 = CHECK_NEAR(polyhedron->vertices()[5].z(), 0.5, 1E-13);
        const bool test3 = CHECK_NEAR(polyhedron->vertices()[6].z(), 0.5, 1E-13);
        const bool test4 = CHECK_NEAR(polyhedron->vertices()[7].z(), 0.5, 1E-13);

        return test0 && test1 && test2 && test3 && test4;
      }

      bool test_faceCenter_CenteredRectangle()
      {
        // FaceCenter:CenteredRectangle
        ff::Face face({{-0.5, -1.4, 0}, {-0.5, 1.4, 0}, {0.5, 1.4, 0}, {0.5, -1.4, 0}}, true);
        const R3 center = face.center_of_polygon();
        const bool test1 = std::abs(center.x()) <= 1e-13;
        const bool test2 = std::abs(center.y()) <= 1e-13;
        const bool test3 = std::abs(center.z()) <= 1e-13;

        return test1 && test2 && test3;
      }

      int main()
      {
        const bool all_tests = test_asPolyhedron_prism() && test_faceCenter_CenteredRectangle();
        return all_tests? 0 : 1;
      }
    CPP

    system ENV.cxx, "-std=c++17", "fftest.cpp", "-I#{include}", "-L#{lib}", "-lformfactor", "-o", "fftest"
    system "./fftest"
  end
end
