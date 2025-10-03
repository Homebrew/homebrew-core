class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_20.1.tar.gz"
  sha256 "672ecc237bc0231510025c9662c0f4880feebb076af46d16840adfb16e8fc4e8"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5c9c97206cb629ff2c8cf50b1887e49ef2e0e8609e26be97303e9b207059c4b"
    sha256 cellar: :any,                 arm64_sequoia: "9dac7d041487c65d0a6fa2162d5dfd29f99e025df2bb0cdf967ef63c028f3308"
    sha256 cellar: :any,                 arm64_sonoma:  "b43c96e5aab90cc4145b8e095421669c51e8a1c14e52f0cb0f153c500910cd16"
    sha256 cellar: :any,                 arm64_ventura: "f251f47deb6a56d12b091c7f08d7677e1082466aca2ea495e4c35b486f17c73d"
    sha256 cellar: :any,                 sonoma:        "d76e33b7686ef11f0b351c0a4ef632f5463d7fc38757558ed76a12b39d45b355"
    sha256 cellar: :any,                 ventura:       "6f215532b131c95676f95194a0f93d1f450143b68953124ee8fe59cd5cc77c59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e66e5256dd17aa4f719f90514fdf2f6be53b55c591e9f1355e64389a72005e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532cca65ef3d681fd80b71e4c0d7140bea31c37916d727357ceb0fdbe23a46cf"
  end

  depends_on "cmake" => :build
  depends_on "llvm@20"

  # TODO: Restore compiler selection when using unversioned `llvm`
  # fails_with :clang do
  #   build 1500
  #   cause "Requires Clang > 15.0"
  # end

  def install
    llvm = Formula["llvm@20"]

    # TODO: Restore ENV.llvm_clang when using unversioned `llvm`
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      ENV["CC"] = llvm.opt_bin/"clang"
      ENV["CXX"] = llvm.opt_bin/"clang++"
      inreplace "CMakeLists.txt", "add_definitions(-Werror)", ""
    end

    args = %W[
      -DINSIGHTS_LLVM_CONFIG=#{llvm.opt_bin}/llvm-config
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
