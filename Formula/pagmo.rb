class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.14.0.tar.gz"
  sha256 "fdb86118812b3885b0c10cd816ec90590a617b5b009b64f1c64635ad2953592d"

  bottle do
    cellar :any
    sha256 "9f964c17fd3fb016149a9f415e9a895e0a90fbf2150d4df1d753767ca7055b7e" => :catalina
    sha256 "c2316bb1dd49217e76cf22e97d1ed19aae37e07521007daa4cc767cb4d160f19" => :mojave
    sha256 "ccc44958d6c995c2523e391befd19078ff2107d335a34037951b1985865e52b8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"
  depends_on "tbb"

  def install
    ENV.cxx11
    system "cmake", ".", "-DPAGMO_WITH_EIGEN3=ON", "-DPAGMO_WITH_NLOPT=ON",
                         *std_cmake_args
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
          // (user defined problem).
          problem prob{schwefel(30)};

          // 2 - Instantiate a pagmo algorithm
          algorithm algo{sade(100)};

          // 3 - Instantiate an archipelago with 16 islands having each 20 individuals
          archipelago archi{16, algo, prob, 20};

          // 4 - Run the evolution in parallel on the 16 separate islands 10 times.
          archi.evolve(10);

          // 5 - Wait for the evolutions to be finished
          archi.wait_check();

          // 6 - Print the fitness of the best solution in each island
          for (const auto &isl : archi) {
              std::cout << isl.get_population().champion_f()[0] << std::endl;
          }

          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lpagmo",
                    "-std=c++11", "-o", "test"
    system "./test"
  end
end
