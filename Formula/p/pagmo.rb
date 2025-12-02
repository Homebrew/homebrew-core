class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "ecc180e669fa6bbece959429ac7d92439e89e1fd1c523aa72b11b6c82e414a1d"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "967ca7afd0f94fe22053b2cf187c97a14c853e160668700db06e8a64f76a704e"
    sha256 cellar: :any,                 arm64_sequoia: "9d5ab6ee707031ed11dd9291c579b778e03ed5357a159fa2fa5c9b572c8fe49f"
    sha256 cellar: :any,                 arm64_sonoma:  "4ec05c1307d3e5375802ddf095106412287eea4024037c4179960564284104f4"
    sha256 cellar: :any,                 sonoma:        "9c6488dd49f684f62e4035943dc9a370a08eed979d71a5139061700570135ff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe0c1de3105984b315801418a3f104de528645485da9ca587777efe7b6da1820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf66c10d87861392ebe1158c0f58ed438190310415b2f2093f53571c00eeaa7"
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
