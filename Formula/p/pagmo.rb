class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "701ada528de7d454201e92a5d88903dd1c22ea64f43861d9694195ddfef82a70"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e11b0ca4289cdec876d0c5199b9827aa7642543b2dd2a2582eaf94a0c9f8b32"
    sha256 cellar: :any,                 arm64_ventura:  "cc442de36fdf67311e88e524191d44b0cecd6ce7ea19d183b03b3e329583b616"
    sha256 cellar: :any,                 arm64_monterey: "a35a8bf54f8f9567f69763bc945542dc75bd55d15c4d5b91e98838fd1a257798"
    sha256 cellar: :any,                 sonoma:         "0814f21c6eec9f52f442b3d9b1a85f44be046ea6fd685516da79743a5429e1cc"
    sha256 cellar: :any,                 ventura:        "202415b8c3313fe6d6d8d0044658781e9d666db88cbbf8b2ae93b228b4455410"
    sha256 cellar: :any,                 monterey:       "7feafbe3220e0f113e78860c69a82dfdc66177e44127a577bb70cba702c36827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3968f0c5fc27aff3fe0d0421009466f6f49a4f2bee2161ad84776287ee1a4557"
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
