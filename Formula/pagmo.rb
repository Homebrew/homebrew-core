class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.18.0.tar.gz"
  sha256 "5ad40bf3aa91857a808d6b632d9e1020341a33f1a4115d7a2b78b78fd063ae31"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ebee22f15722c58adacfa57e6055e3502f31465a6dde926f6f672fbee3769516"
    sha256 cellar: :any,                 arm64_big_sur:  "cd404df2a833a26b171b51f1e00b765e6f796ca3fc2146ec253e6d626c7b1f5e"
    sha256 cellar: :any,                 monterey:       "4b128647772e649ffcadfcabe191c5d6d1253b01056fdc56195040037004980f"
    sha256 cellar: :any,                 big_sur:        "f87d29fadc20590569a49deb4794f4b5ba7783970b13909654f0a66485c029ec"
    sha256 cellar: :any,                 catalina:       "9b225065bc980d683923746a6d88ce1d3f5fe02b9881cac6aa25b037cce5fab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e669f76c3d5f5dc9c40a47d38f46368f822190f56a58bbfe52a981f1b3061a00"
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
