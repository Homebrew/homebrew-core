class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.18.0.tar.gz"
  sha256 "5ad40bf3aa91857a808d6b632d9e1020341a33f1a4115d7a2b78b78fd063ae31"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_monterey: "26f757c02d4e087032f684151fcf5c1f202e82b77c12520ecd0fc9e3c1063831"
    sha256 cellar: :any, arm64_big_sur:  "4078c9db26232af1918e92c1fe2f452eb346fe07564cf49ff6cf840164f3f0b0"
    sha256 cellar: :any, monterey:       "38b19943404fcb304e69a51f0e96e3f229080ece753977a083e5d20071034a67"
    sha256 cellar: :any, big_sur:        "e3fe9ef3f10e0f3a8a374afb3ce6dde2eb1a4e269fb810cc18e7be641a638c81"
    sha256 cellar: :any, catalina:       "f5623fc821e2df72e40215540dd642841777bc925926315a373818d31fe58b33"
    sha256 cellar: :any, mojave:         "7c5416e486a9683c6a919717a5c3bfc1ab2dd294f7c328fcb3a9cdc7b535aac5"
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
