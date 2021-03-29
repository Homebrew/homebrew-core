class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://github.com/rabauke/trng4/archive/refs/tags/v4.24.tar.gz"
  sha256 "92dd7ab4de95666f453b4fef04827fa8599d93a3e533cdc604782c15edd0c13c"
  license "BSD-3-Clause"
  head "https://github.com/rabauke/trng4.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fbf1971402ee149d4a60e6dec96a2c44ca500871848e0a5bd4974ce4f8b11369"
    sha256 cellar: :any, big_sur:       "8eff7623b750819d2bc64e993601623805898bc279b0790841485e4c089735cb"
    sha256 cellar: :any, catalina:      "b0e5af117a32d265de30662de4d7ef61e412853f262949e86ac1ff91dfd69875"
    sha256 cellar: :any, mojave:        "4b753374a4fb6305e417ea5d89237f6e62b47b8c9e2c034c76e26475184de48c"
    sha256 cellar: :any, high_sierra:   "4f269f561d5b8b692189e90cba163578ad68b2fa83a84660d8da4d367c4a2e93"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
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
