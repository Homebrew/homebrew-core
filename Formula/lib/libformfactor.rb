class Libformfactor < Formula
  desc "C++ library for the efficient computation of scattering form factors"
  homepage "https://jugit.fz-juelich.de/mlz/lib/formfactor"
  url "https://jugit.fz-juelich.de/mlz/lib/formfactor/-/archive/v0.5.1/formfactor-v0.5.1.tar.bz2"
  sha256 "1394b6c8d08a7ffd19a5f74b1f187d1537a398199fe22ac78c2d441a278e49ae"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d6ed20ea820a3bbfc39bfa54acf1dc0ae6c3be6f4fae05e6ffc9ad40e2b5706e"
    sha256 cellar: :any, arm64_sequoia: "f78124b91494b63720a9e1715660480d9c7b60a48eae20d26df180408bbeac62"
    sha256 cellar: :any, arm64_sonoma:  "ce60d6a12b38bfa806e2ea23aa02a319947402d4a697b8df5f749c8545263f90"
    sha256 cellar: :any, tahoe:         "97512da00fd1cd73585b59921d6b35ed23d3c7d515a2e2cc2a925a6539bef0b8"
    sha256 cellar: :any, sequoia:       "e373f8ae492d35dbadb058860a0e88f1a01a2a8a83c860e89ee3a5c715029d31"
    sha256 cellar: :any, sonoma:        "474ddad22287c63bd0e222d94d7fa552194301044f20fcb9845297446a946955"
    sha256 cellar: :any, arm64_linux:   "50eaad281e372b31a35fa5aa5c25f3ea9b39d0923487faa1af3333af3cefecfc"
    sha256 cellar: :any, x86_64_linux:  "ff1747fba1d74e5b92ab1661fb4a2cfe9688ecd1012cf2f199493fa9ba993a34"
  end

  depends_on "cmake" => :build
  depends_on "libheinz"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLibHeinz_DIR=#{formula_opt_prefix("libheinz")}/cmake",
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
