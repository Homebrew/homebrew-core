class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.18.0.tar.gz"
  sha256 "5ad40bf3aa91857a808d6b632d9e1020341a33f1a4115d7a2b78b78fd063ae31"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af3498b215e2f9d649acd0b0117c873329fb85183ddee69cc9525c75f7c02a99"
    sha256 cellar: :any,                 arm64_monterey: "6e9f221a9c7d5fc475c10b71ed61f975ec935b60ce95b2a5d386a48d3855a8eb"
    sha256 cellar: :any,                 arm64_big_sur:  "7d41e40c5cc13fdccf10797ae625d997e9b3f144bfe47a5e473ba8f4803d7588"
    sha256 cellar: :any,                 ventura:        "52fd8fa749297993c064a8c6271ad9e1b3e8433b201a856a6d6610ff477d13d4"
    sha256 cellar: :any,                 monterey:       "0ffd37782e82eb101546316c117d70f6f2cab6e780f4c47cf60095551246d670"
    sha256 cellar: :any,                 big_sur:        "f40421043c90181ffb0f59eb1b8e79fdf43ebbb5efec79cf5453e69554b250c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "322f06e922c7b3368e6396e28b625a1863906021570b6494b516c2f9b304b6d0"
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
