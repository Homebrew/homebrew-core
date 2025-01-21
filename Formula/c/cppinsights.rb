class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_19.1.tar.gz"
  sha256 "88853a67b9eaf6917c531071436a275c62f1dcfe6f2e02e521c39ce81b05e6a7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd9ff90a4c18618444e8aa6fbb2d3f83fa9450ca19e88b166cb7984e566acf2e"
    sha256 cellar: :any,                 arm64_sonoma:  "a77a5abbd96b6aa0d47bf09187ede25457ade5570a71f996b174fc631ec38cb0"
    sha256 cellar: :any,                 arm64_ventura: "181c1ef524e834aa0b2974363173c86c186c9f18b7ab67d593e4d640398b3281"
    sha256 cellar: :any,                 sonoma:        "506c9a94441c12056bcf5edeb77d1308076a9ac8cb28ed01ee9a7d9025cff28d"
    sha256 cellar: :any,                 ventura:       "7009e97127fee0124103b9a4966beb85bb6cb5801d708270dffba7702ea4b8eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc1962e932cdd04e649b28111d04e53ba7f5a26441ba702b54d85de7f2ce0a14"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with :clang do
    build 1500
    cause "Requires Clang > 15.0"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    args = %W[
      -DINSIGHTS_LLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config
      -DINSIGHTS_USE_SYSTEM_INCLUDES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      int main() {
        int arr[5]{2,3,4};
      }
    CPP
    assert_match "{2, 3, 4, 0, 0}", shell_output("#{bin}/insights ./test.cpp")
  end
end
