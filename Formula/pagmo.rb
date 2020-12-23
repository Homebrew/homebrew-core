class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.16.1.tar.gz"
  sha256 "45f2039f2198b6edadf81bdefb10a228f9dd087940c1f1ab1882098f16581df0"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]

  bottle do
    cellar :any
    sha256 "1c14b0600379cf50ff93ca0a351332f1ccbf0155ff88a354ae8f241ff9a1904f" => :big_sur
    sha256 "600c1182294a7790b4679493fbf43fb2c217d4675c8a1685ad79428de56484d1" => :catalina
    sha256 "772c1b5fc64fe55fb9b26bfedb29f14bb92bfaeeb28386a816341cedc8245eb2" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"
  depends_on "tbb"

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
