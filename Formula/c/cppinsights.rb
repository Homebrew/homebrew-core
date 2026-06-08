class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_21.1.tar.gz"
  sha256 "205361d9a19e78a7bfe62b673fc1f86e41af6f6bae37a427c2be2e2444171ff2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c90332769d11df6c4f53571711bc957fd3dd9b85efb36cf8514ec4b68f536763"
    sha256 cellar: :any,                 arm64_sequoia: "08003aceaa6b2252c6b05cf8f5800cd7b38f0fb3e3f9761ae15bad20a1893028"
    sha256 cellar: :any,                 arm64_sonoma:  "14204b9de05e74325bcdb50588d6a7ce1549d621b8b256aca59fa25fa567f941"
    sha256 cellar: :any,                 sonoma:        "d066316a0e075f75bf5681bca990302e2391c986198473c0d4412a237026fa27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24f0a681d41862e78db82eadb6334ef1f94a73136281ba9c5b4d7598a8961f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "378068391598d3fd0e3a53212ab3d9541391e19fa38ae27f0b6fd572ca873a17"
  end

  depends_on "cmake" => :build
  depends_on "llvm@21"

  fails_with :clang do
    build 1500
    cause "Requires Clang > 15.0"
  end

  def install
    args = %W[
      -DINSIGHTS_LLVM_CONFIG=#{Formula["llvm@21"].opt_bin}/llvm-config
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
