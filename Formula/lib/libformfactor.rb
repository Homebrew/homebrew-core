class Libformfactor < Formula
  desc "A C++ library for the efficient computation of scattering form factors" \
       "of arbitrary polyhedra according to Wuttke, J. Appl. Cryst. 54, 580-587 (2021)."
  homepage "https://jugit.fz-juelich.de/mlz/libformfactor"
  url "https://jugit.fz-juelich.de/mlz/libformfactor/", tag: "v0.3.1",
      revision: "b8d85438b05050f0251c7a25f0c7426eeeb78ae6", depth: 1, using: :git

  license "GPL-3.0-or-later"

  depends_on "cmake" => :build

  resource "libheinz" do
    url "https://jugit.fz-juelich.de/mlz/libheinz/", tag: "v2.0.0",
        revision: "60db9bb697fa12ace4c8ce737761aa2fab03d27c", depth: 1, using: :git
  end

  def cmake_exe
    "#{Formula["cmake"].opt_bin.realpath}/cmake"
  end

  def ctest_exe
    "#{Formula["cmake"].opt_bin.realpath}/ctest"
  end

  def nproc
    [Etc.nprocessors - 2, 1].max
  end

  def install
    build_dir = "#{buildpath}/build"
    opt_dir = prefix.to_s

    # build libheinz
    resource("libheinz").stage do
      system cmake_exe, "-S", ".", "-B", "build", "-DCMAKE_INSTALL_PREFIX=#{opt_dir}"
      system cmake_exe, "--build", "build", "--parallel", nproc
      system cmake_exe, "--install", "build"
    end

    # build libformfactor
    system cmake_exe, "-S", buildpath.to_s, "-B", build_dir.to_s, *std_cmake_args,
           "-DCMAKE_PREFIX_PATH=#{opt_dir}"

    system cmake_exe, "--build", build_dir.to_s, "--parallel", nproc
    system cmake_exe, "--install", build_dir.to_s
  end

  test do
    (testpath/"fftest.cpp").write <<~EOS
      #include "ff/Face.h"
      #include "ff/Prism.h"
      #include "ff/Polyhedron.h"
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
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "-L#{lib}", "-lformfactor", "-o", "fftest.exe", "fftest.cpp"
    system "./fftest.exe"
  end
end
