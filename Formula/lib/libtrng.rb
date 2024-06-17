class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://github.com/rabauke/trng4/archive/refs/tags/v4.25.tar.gz"
  sha256 "2727ce04e726a0b214e7bc8066793489b1ddce2fdf932d63313f4fd2823c9beb"
  license "BSD-3-Clause"
  head "https://github.com/rabauke/trng4.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8257549668db1ad3e6cce3a09eb86bc19625d293ab1d79a9c3f9b64a7602114"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1196fcff705fdf7c4de517d463fd69727e09432d8e9a7c433678337193cd29a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb53432989d3d92094ac9946fc9ec710ed62bf74632307c2033eb041a5d69c98"
    sha256 cellar: :any_skip_relocation, sonoma:         "82030b459f055448cc48fb9a5c0018b58b27816ca03816efcf2441887dbfe2ee"
    sha256 cellar: :any_skip_relocation, ventura:        "60ffdd162492855567c734df2944d83064bc29eaafeda09f85360a087f313e34"
    sha256 cellar: :any_skip_relocation, monterey:       "6f4567d5234247880921ed3755bb9941d9aa6f0b79d6805b19b6154505888dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ebdbe801578fef0d327a7b181c142d1602e347a3779ce18398140c662c0349c"
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
