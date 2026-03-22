class Libformfactor < Formula
  desc "C++ library for the efficient computation of scattering form factors"
  homepage "https://jugit.fz-juelich.de/mlz/libformfactor"
  url "https://jugit.fz-juelich.de/mlz/libformfactor/-/archive/v0.3.2/libformfactor-v0.3.2.tar.bz2"
  sha256 "b5cdb57fcbde6b39e314d7a040466a863f25625f112057e6d369a9ea5049dc1f"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3203be1b64215626742226e0cf2711c99798d8a8f898235dcb7b653306acd5fc"
    sha256 cellar: :any,                 arm64_sequoia: "bec52e88151038c736cac82a2715adac4f5dd1c8a2a57a6845ee98391c730406"
    sha256 cellar: :any,                 arm64_sonoma:  "2e8443d960fbc50875813f5906f8193c17c6a04b81b2ea53d10a72f5c9c7ba60"
    sha256 cellar: :any,                 arm64_ventura: "cbd1accc07443366fd295ba1b20ba5f70dc26ee1d649f21617a35f215b1fae24"
    sha256 cellar: :any,                 tahoe:         "f7ecb95122cbdc6b9c398418241ba77166fd77a86baa7e2c6c2a1287ecb3fc8b"
    sha256 cellar: :any,                 sequoia:       "8b8e8eeab3099b87c2e5034ba25ed829d1bf20dad5f6a68ec5b4c18e4eca9699"
    sha256 cellar: :any,                 sonoma:        "9ab41b2ed309b86ecb8d90d18b47a73c9be3e4779879ff7ccc22babe7f6312c1"
    sha256 cellar: :any,                 ventura:       "7b1c98c43cf7f6cec9553db573d2bb77c8dcc7c5b14f178cc2bbb41b0038b2a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54c8721ccd5e957cec42bd4d02da01c1e4a69045728761789c7696b9b094c46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f95d0067c89d6cb77ec92350dc88f9f67731337b1ceaacac2e9288f05668d8"
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

    system ENV.cxx, "-std=c++20", "fftest.cpp", "-I#{include}", "-L#{lib}", "-lformfactor", "-o", "fftest"
    system "./fftest"
  end
end
