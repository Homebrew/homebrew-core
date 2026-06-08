class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "ecc180e669fa6bbece959429ac7d92439e89e1fd1c523aa72b11b6c82e414a1d"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5474b826c3a4d2e4e0a557f8cae80452cf73a24e9ba1b6f375c1d9e78f18f77"
    sha256 cellar: :any,                 arm64_sequoia: "c3b9817551e40a0827cecef5f15ab2484e5805e0d43db105139a8f2cbaa1adc8"
    sha256 cellar: :any,                 arm64_sonoma:  "fc7994d99b3d470899d7e6c6a2af827885f4d4fefa4a69d20003cc0199d99454"
    sha256 cellar: :any,                 sonoma:        "41e957d1c2b853bfeebdfbd0b0b5631a34488f5b978223dad6826dd88f77e7af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c931f2ce4aaa87aa3e902e43a50f3ff5bc00d3edf452b8f06eca47aaa2fdf53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd3e376bb093f8d4cbd0af34edfbbab0f2d2a637233cce82e9559f5dd92334c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"
  depends_on "tbb"

  # Backport support for eigen 5.0.0
  patch do
    url "https://github.com/esa/pagmo2/commit/bdd8559d7663536c3a5f56b013f07da11a35c9b8.patch?full_index=1"
    sha256 "f8679d6ca0d4bd5d9b44382da35ddc6f80404d389813ce05f050d00f5ce3706c"
  end
  patch do
    url "https://github.com/esa/pagmo2/commit/d0e70403179769c326f2694673473e1d3ef0bec7.patch?full_index=1"
    sha256 "6dcf5ac2cbd8e9b0de20845a51ef5d8eeb0ffd0472f32bcc833ce3f314718f0b"
  end

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
