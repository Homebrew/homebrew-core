class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://github.com/rabauke/trng4/archive/refs/tags/v4.28.tar.gz"
  sha256 "50432094f8a4b079bcf1c4a9075691c34f4ed5be54835d7ea1a38ccb00ebc89e"
  license "BSD-3-Clause"
  head "https://github.com/rabauke/trng4.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad985638bc3b77cc8bc4799fc9f2e14fde33bc35f40bb7bb3bed57eef38c3784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "407860b1c724e65566682084b41a25cd77b01aa400e428087e5bf6dc50658f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c75bac852bc43e36b89b2793936517ce845d45039b23153c8fa8f902eef231c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "34c5bf9ea238155fdf3a37adec7289c3dacfd405bb4b01acdc833d4e6dc93ab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f0d019d2da69dc4ca61cefcc60a0318b214662e170b07d89d0ff0f66b7997fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7431c289154cb26f6fa6ef537344aea1b6068cdb0763cc8aba25f034e4b9d55d"
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
