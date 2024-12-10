class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "ecc180e669fa6bbece959429ac7d92439e89e1fd1c523aa72b11b6c82e414a1d"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cf7927509223529577b157990ee0ddbfc63919bbd92fc1d307d8f4f8a2707fd0"
    sha256 cellar: :any,                 arm64_sonoma:   "8a0afc6cc97987dbf0d331490c278b4a739306e21d8cdd6abee1595056991cf6"
    sha256 cellar: :any,                 arm64_ventura:  "8d8ac532e972fc741ef96a550adc2fbbcec5576e750cdf4f28c9edd585b54a98"
    sha256 cellar: :any,                 arm64_monterey: "553b6d9439f07679e0f7f5819e459d9f8bcd8869328c506755be103b40c59e17"
    sha256 cellar: :any,                 sonoma:         "deda63403b6b445b4418160f30b8eb48e1e8bf1763b95ece54f0a44e9c559a52"
    sha256 cellar: :any,                 ventura:        "0ff2034f5a451de4f483e3916842fc559d6665ea3fdaf5ccc01d3f2725370b63"
    sha256 cellar: :any,                 monterey:       "787a36f0baf71e9c858e114da69902b446447c6d74383292da02b097dc1d54bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033a66f14e5276aa4b64bddc1114539bc2cc99eae1ce4ffd1e84a01413aaff88"
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
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lpagmo",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end
