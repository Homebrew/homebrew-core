class Libformfactor < Formula
  desc "C++ library for the efficient computation of scattering form factors"
  homepage "https://jugit.fz-juelich.de/mlz/libformfactor"
  url "https://jugit.fz-juelich.de/mlz/libformfactor/-/archive/v0.4.0/libformfactor-v0.4.0.tar.bz2"
  sha256 "9e5f0458c78751121e0efa572f9a03e5965fe8ee2d4ff34939b6cce9bfdc8c36"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9607729d3bafce681cb6678cf675738a1a98f87d613592317a9a96c29085a8d7"
    sha256 cellar: :any,                 arm64_sequoia: "3ebfbb57a42e68ac20053ee98bb257a6b7670b4c8a1d4719bc2697477e4f8024"
    sha256 cellar: :any,                 arm64_sonoma:  "e4e54cd941e921522620cd8029646213047f4ca9e10f2371361a2c40617f3c49"
    sha256 cellar: :any,                 tahoe:         "cebe06822c0a0e5d597b3f076d805f8fd39b72ab73b1f017acabacf8d04e2897"
    sha256 cellar: :any,                 sequoia:       "52bc4e72d0b86f5cd3b613e9887b0d98e3b4e7c0a050c2bd9b6666b976dcd18f"
    sha256 cellar: :any,                 sonoma:        "f24757b59a0dd170f63c7726db7b9e8690a30a7331c1cca2a4db5846bbc672a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54bb006639bc9991f2f5ff88f066f4013e1ac4da21b0e482541c9fd526a42213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8771a938b477f59832c5a62d5e142d20c3ffd3abc101887a38d414d88e173c03"
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
