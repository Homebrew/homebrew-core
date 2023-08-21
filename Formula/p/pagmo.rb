class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.19.0.tar.gz"
  sha256 "701ada528de7d454201e92a5d88903dd1c22ea64f43861d9694195ddfef82a70"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0d699efa58477387d7144cf25c91c1809d3c95e8e4eff135dd5d3385ceb8fb35"
    sha256 cellar: :any,                 arm64_monterey: "967930e4a14276c3159edf5e8d3dac7ad6cf39b8727b5f5479ddf7677c1ec366"
    sha256 cellar: :any,                 arm64_big_sur:  "da4daa92ea36eafc36a7eeb0895add7a8a28f35780e4856e2c90f3709d85645c"
    sha256 cellar: :any,                 ventura:        "e87448b08bb3eef888de8becfda13b7d3b02353320a3cdcb7d0e18a307cbdca2"
    sha256 cellar: :any,                 monterey:       "a87d2af510454417523cce4c4d0566d160ab396fed05bc90161ddb9df3d286ca"
    sha256 cellar: :any,                 big_sur:        "760c2abca386c2cee9121af707f3eec8ffdba239e75da6a8b8e0fed1ba14f782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8550690a470ee13f5418de7841be6aab0672cf5847f04eaa39189e84bae45ea"
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
