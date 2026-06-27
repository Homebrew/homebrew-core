class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://github.com/rabauke/trng4/archive/refs/tags/v4.28.tar.gz"
  sha256 "760dfd6a67e10c325ec1c5b61f1ec55a7c1081ed9384066926d0d1df3018787d"
  license "BSD-3-Clause"
  head "https://github.com/rabauke/trng4.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87e5143df567277305eb5a70f6a54eacb567b1a8d5fc39064cea5f04cfbdd382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcab51eba132917f715e4513e16f5dd90a745d2868fe825b9ee6e391cba42cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09a49048439de393c9cd662c8cce10ce41f18afb515cbe0f7bb50044198651b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d0f9eac4e1aac1d3b082e32ca16e68c84ab0dddd7b5b78246091d565d3dda97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bc2cf81d9f2e6c5117ec0d5bebf2e9653c307e969649534ebfbbc344d368bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1943000edda2dc1941a79b7a11d1c3c74539c3f0eeb6ad9f53e5ea6f530c3e51"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DTRNG_ENABLE_TESTS=OFF
      -DTRNG_ENABLE_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <trng/yarn2.hpp>
      #include <trng/normal_dist.hpp>
      int main()
      {
        trng::yarn2 R;
        trng::normal_dist<> normal(6.0, 2.0);
        (void)normal(R);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-ltrng4"
    system "./test"
  end
end
