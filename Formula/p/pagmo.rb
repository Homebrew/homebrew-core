class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "ecc180e669fa6bbece959429ac7d92439e89e1fd1c523aa72b11b6c82e414a1d"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f4257366200beb78f2385c1b4d2fc62e81599415827d213200b7403682d54b0"
    sha256 cellar: :any,                 arm64_sonoma:  "5f1c8021bf68ac533e781a06c1d02d03697b85336de041899a8d05226768c09c"
    sha256 cellar: :any,                 arm64_ventura: "ad960b3a69b6283e74399cbe09fe941a13183815c7f26d0f0fd111883c166e8e"
    sha256 cellar: :any,                 sonoma:        "feec9497fbae6ea91e8a2a55dc4a03b5b784731eeb540620233c9f01b0d78828"
    sha256 cellar: :any,                 ventura:       "0f83b648ec1a642473ba6b71c29cfc1c8f37fcfe8fcb87112624839cecef4424"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91420f1fbcb0890a1808493d3a47b965af26f7f6824905093f1aff100c651d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb61eb3620d314de4a02ac9450b6be46326faf7180f8c19d98ca5046cf918fe"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"
  depends_on "tbb"

  def install
    args = %w[
      -DPAGMO_WITH_EIGEN3=ON
      -DPAGMO_WITH_NLOPT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
