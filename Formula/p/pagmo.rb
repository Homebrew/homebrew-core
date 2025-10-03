class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "ecc180e669fa6bbece959429ac7d92439e89e1fd1c523aa72b11b6c82e414a1d"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "970141f824a1df8a43acb58e2d7f833d07b6fc783805fbeb691dafc8611c2f4d"
    sha256 cellar: :any,                 arm64_sequoia: "d990228017c8de47ef6a251f01d9d3f1256692df3516459b13bbe9b409e45400"
    sha256 cellar: :any,                 arm64_sonoma:  "a6f6f191b85a838faf5d10addc32f9f8e6565c4317caf8867bc80ce17d2ead44"
    sha256 cellar: :any,                 arm64_ventura: "436417c8ba3422bd8fe6f3a5e8c5a20cd3256baae1137f3a928343303891414d"
    sha256 cellar: :any,                 sonoma:        "669f2fed9d5aac73db355fa9ca25c2f16f9dbf32eaa9aae56ab9b2dc707e089c"
    sha256 cellar: :any,                 ventura:       "3327fd6748b1d7cb0fffe50f567e9baea9c088e6c9c2e069aa1073ecd16fb2f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44c6934ddde022ea5fbdeb64b5a8dfa0f0b3ad01407b051023a3ad274552fbd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee1febbdbb2ebf081daef299a4cfbaea9b3f3182bd3efa0583fd2dee8bf1322b"
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
