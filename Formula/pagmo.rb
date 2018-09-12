class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.9.tar.gz"
  sha256 "d482650e0c79a49ce0312c7e9e5722f3a1b24327e08af11daa66c59374bed3b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbafe3f25a46bc9393034034e3c4ec0d646e0f05156d0c40f9e18dfca4cbb36b" => :mojave
    sha256 "1dc34d7efa473a43c7edb99a2bd2c2cc827eb2562ff9ffc28cc66043e9f91680" => :high_sierra
    sha256 "1dc34d7efa473a43c7edb99a2bd2c2cc827eb2562ff9ffc28cc66043e9f91680" => :sierra
    sha256 "1dc34d7efa473a43c7edb99a2bd2c2cc827eb2562ff9ffc28cc66043e9f91680" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"

  needs :cxx11

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
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-std=c++11", "-o", "test"
    system "./test"
  end
end
