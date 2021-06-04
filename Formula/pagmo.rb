class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.17.0.tar.gz"
  sha256 "1b95b036f75e6fa0b21082ab228dbd63cd18ca10d9622ac53629245e0f95c35c"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "18181c38174404acd3ec9b853b88de61fa41976151af65dc3b00661c0e52ad02"
    sha256 cellar: :any, big_sur:       "f925711ad560087a289428805994d0ead7f36908476f0dcb402f6c1530e4dcfc"
    sha256 cellar: :any, catalina:      "98091a111b8ad43f56c74182745934655a1c8b86a2988b3437e41f69cc432741"
    sha256 cellar: :any, mojave:        "d9afbf9ba54aef2340a7e19bc4974673b53650307a0da94943e12db993295cae"
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
