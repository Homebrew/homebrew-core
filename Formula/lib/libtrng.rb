class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://github.com/rabauke/trng4/archive/refs/tags/v4.27.tar.gz"
  sha256 "5d04cc66b7163c869c061c1155e47fe6d54d9a7f1c1fcc0fddecb9269b66a3de"
  license "BSD-3-Clause"
  head "https://github.com/rabauke/trng4.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ca31ee58ef7b75496782b4067e5f78483818ce71b73ec8482f0e11050da4ca60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "11b03794419841493fa21c0c665500001430158450404de1e9ef092e62305869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a1bfdc55b371cb19aca7ea1febdc675ba72fb60a6bfe316fdbabca2d6a230df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa8dd27d28cee66e6e8b9b1b3e2776301c11c2785125e7a2d830d61338f841b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f9d4aba3f1650ba79184a3d2c959156a90f8b83f545cf53e9264d8e0c623645"
    sha256 cellar: :any_skip_relocation, sonoma:         "f94814bf56e5b761119f7a33904dd3c4895691018be79c8934ab145622f93b8a"
    sha256 cellar: :any_skip_relocation, ventura:        "c1a58202bea8f27b2536caa21b8deb2e8262cb79bdea6dd7c59c016793c8c14f"
    sha256 cellar: :any_skip_relocation, monterey:       "a92a32f26d5aa37518d5833705493fbee25149ed6a80be7f743422cdca9d8316"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "708d01a459562714fea9eae25da01662acaa5b72c45d177e6e39e37941cc4f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6280ea4740a8de759219fe78f9a2610b02065c2c16e63c892a60017395b3d1c6"
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
