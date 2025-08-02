class Libcaption < Formula
  desc "Free open-source CEA608 / CEA708 closed-caption encoder/decoder"
  homepage "https://github.com/szatmary/libcaption"
  url "https://github.com/szatmary/libcaption/archive/refs/tags/v0.8.tar.gz"
  sha256 "8567765a457de43a6e834502cf42fd0622901428d9820c73495df275e01cb904"
  license "MIT"
  head "https://github.com/szatmary/libcaption.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1e6bc1217ae5305e8162548acdac009df7edc970016f8e65715268098958c5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb4a940016239f432d43d23c9a416a99edfe912e10eea43b976b39924ae028f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3699e0e6939851149651a60d8544f7ebc194a6d79f6e835d9ea36803f9b8a8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7e178fc19e4d5f815d2210036f2fe830a32546231fd917d9e68b37ecaef63c"
    sha256 cellar: :any_skip_relocation, ventura:       "39432e5e175d5a277097d328795b7e071ec80ecd93be1d0d396be670d79dc4e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87d59136b4f50c2ccbd626f1a83655f2652f31ef8b8916b4822c645f2fa443f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f739c811db204ee8daf42272b61ef2b4e81e73d0bd52ad7e1914a2e14090df6"
  end

  depends_on "cmake" => :build

  def install
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    system "cmake", "-S", ".", "-B", "build",
                  "-DBUILD_EXAMPLES=OFF",
                  "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                  "-DBUILD_SHARED_LIBS=ON",
                  *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <caption/cea708.h>
      int main(void) {
        caption_frame_t ccframe;
        caption_frame_init(&ccframe);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcaption", "-o", "test"
    system "./test"
  end
end
