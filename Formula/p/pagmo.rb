class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "ecc180e669fa6bbece959429ac7d92439e89e1fd1c523aa72b11b6c82e414a1d"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de89536a11df055792e5438ec658c6cd16c55315b84c6c424b49e3982a9dbd44"
    sha256 cellar: :any,                 arm64_sonoma:  "b3ebceb0271d0a389f1ae4078941e8269c9efbec372e5305a172102de4b74f8f"
    sha256 cellar: :any,                 arm64_ventura: "1154611438e8b1316c7f3f8ce0951deab54322bf5537b59494eec4106f8a7e48"
    sha256 cellar: :any,                 sonoma:        "5f3bef1e0ed24dfbbde890a7b5b2474b585a1cdbd412c559d6a54043ed378c76"
    sha256 cellar: :any,                 ventura:       "d4f0b7cbda497ce7f766efd08984bd52534a2ceddb7e070c91213bfba60a0567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3a36065e0fc45e3705fac89c77412947deb37532f777538d8aa98bb71d8abd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c3b4f42b1a460e73058cf7e82ce44fccd069ba476755ba37c0c07ff78787d34"
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
