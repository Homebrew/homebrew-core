class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "701ada528de7d454201e92a5d88903dd1c22ea64f43861d9694195ddfef82a70"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74848a6d33ff15f49535e54fd072888884fe03326d28be62b57a1ff3987359be"
    sha256 cellar: :any,                 arm64_ventura:  "d7b9590b8add425a5524e691bc9581c8e18ca4fd4ae021eacc8c9d357d9b7c3a"
    sha256 cellar: :any,                 arm64_monterey: "c4b3f119dae48013dbfa64fa78d9d20daff88b410ad66191053aa0ce98b7f3d9"
    sha256 cellar: :any,                 sonoma:         "889ccd3f2801d85a95995559d98cd31baecb2242f048bf73cedc4a3bc0a92e50"
    sha256 cellar: :any,                 ventura:        "f036624926ec42eee682d1183d1df793bf4c497e36a7814c741df16a4b71e7c4"
    sha256 cellar: :any,                 monterey:       "1521d43fcb56388acd8ea97d349d7bb40b980356f4ff186370e724a6c981f085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dbf74152c4aa9ee8a8d209899e586ff093c83f5d6c32dcf891442e05303e7c7"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"
  depends_on "tbb"

  fails_with gcc: "5"

  def install
    system "cmake", ".", "-DPAGMO_WITH_EIGEN3=ON", "-DPAGMO_WITH_NLOPT=ON",
                         *std_cmake_args,
                         "-DCMAKE_CXX_STANDARD=17"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>

      #include <pagmo/algorithm.hpp>
      #include <pagmo/algorithms/sade.hpp>
      #include <pagmo/archipelago.hpp>
      #include <pagmo/problem.hpp>
      #include <pagmo/problems/schwefel.hpp>

      using namespace pagmo;

      int main()
      {
          // 1 - Instantiate a pagmo problem constructing it from a UDP
          // (i.e., a user-defined problem, in this case the 30-dimensional
          // generalised Schwefel test function).
          problem prob{schwefel(30)};

          // 2 - Instantiate a pagmo algorithm (self-adaptive differential
          // evolution, 100 generations).
          algorithm algo{sade(100)};

          // 3 - Instantiate an archipelago with 16 islands having each 20 individuals.
          archipelago archi{16u, algo, prob, 20u};

          // 4 - Run the evolution in parallel on the 16 separate islands 10 times.
          archi.evolve(10);

          // 5 - Wait for the evolutions to finish.
          archi.wait_check();

          // 6 - Print the fitness of the best solution in each island.
          for (const auto &isl : archi) {
              std::cout << isl.get_population().champion_f()[0] << std::endl;
          }

          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lpagmo",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end
