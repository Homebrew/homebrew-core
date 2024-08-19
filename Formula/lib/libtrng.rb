class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://github.com/rabauke/trng4/archive/refs/tags/v4.26.tar.gz"
  sha256 "b6646d911862edb5a35e1a633b2ebbe8b5e66a4147d1c075f35d18f49467a864"
  license "BSD-3-Clause"
  head "https://github.com/rabauke/trng4.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63b6c95f69435eee51f4eba5aa10d2669f429b50a0ecadf69c9936ebc89912d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a682682e919e6a21550328aefa64cd679312d64bd9be301d4055de7b2835787c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44b7c200d2bae8f616c10622d3c083b2982af60d6e56203ba5803d4243bcac1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4bc10c526627980dc2df8e92b6f5b784fb88c17d2d7cec56153189e039f63bb"
    sha256 cellar: :any_skip_relocation, ventura:        "7238e2d2a1fe040aa51207d80055080fa9a8e5d6c3b443f67a7ceefd87a01c57"
    sha256 cellar: :any_skip_relocation, monterey:       "ab4266b5054f8377da9f268489ffe7d115491cc58ec6cb97e9a232faecda41c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b48064ab72bed694064419d269a6ddcb51dadc98cd417ff7ce2d1b8cbf005dc"
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
    (testpath/"test.cpp").write <<~EOS
      #include <trng/yarn2.hpp>
      #include <trng/normal_dist.hpp>
      int main()
      {
        trng::yarn2 R;
        trng::normal_dist<> normal(6.0, 2.0);
        (void)normal(R);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-ltrng4"
    system "./test"
  end
end
