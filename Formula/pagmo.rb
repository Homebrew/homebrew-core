class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.19.0.tar.gz"
  sha256 "701ada528de7d454201e92a5d88903dd1c22ea64f43861d9694195ddfef82a70"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "310df884da16bdb83fc9d1d890f4badfeafbfcc5d26e3182b516b8816ddb50f7"
    sha256 cellar: :any,                 arm64_monterey: "765c33daf58fb08fcb240bd60c3bd6c72d7a16ce83da175c9693f766107e5592"
    sha256 cellar: :any,                 arm64_big_sur:  "6298767893209c1e81b3c6ded53f84581c30a1b288b5c9d2ca27d1cd3a97c9d5"
    sha256 cellar: :any,                 ventura:        "dd5652d55e5c58c22e93fbf8b895b6cb8563c109f1a0f58c9293a97e899bfc9d"
    sha256 cellar: :any,                 monterey:       "eab152f7b7620d1afb8db53642f7da540a656cd13e742a241ca658c9928deecd"
    sha256 cellar: :any,                 big_sur:        "afe5a7c7f449f3bcbae91a9d23d9548828ea3ebaaf992c4a6e9152283c58406e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4b1be604b7367a9719ce437d12f6bd72f8c821bdb5e639ed6f7cc921d4bb7fe"
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
