class Dynet < Formula
  desc "Dynamic Neural Network Toolkit"
  homepage "https://github.com/clab/dynet"
  url "https://github.com/clab/dynet/archive/refs/tags/2.1.2.tar.gz"
  sha256 "014505dc3da2001db54f4b8f3a7a6e7a1bb9f33a18b6081b2a4044e082dab9c8"
  license "Apache-2.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9b3ca5eca8723487de3b6a864ade40fd1f9fb041a4c8cd45bd39356da50c576"
    sha256 cellar: :any,                 arm64_sequoia: "5ee2e5895fb8f27869a3f6449e4ab88b63f4b8c9b716e4e4cf5aa3fec9a6e5c1"
    sha256 cellar: :any,                 arm64_sonoma:  "575b4161502613978a741cbb612833a9071f31a2a159095e74620686505ad72c"
    sha256 cellar: :any,                 sonoma:        "743082c372e91418ca92666f7e8185e041f76d014f32cdd97c4b2caf2882f08c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f4abdf14637d8a9fdc3b85c37061a38001bfff9ab87714b21cc1c5845dc4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e49f33563dedf584dbf05c93b537775ddc36bdd62bb0d9d7c7325e4a2c73a4d6"
  end

  depends_on "cmake" => :build
  depends_on "eigen@3" # cannot use Eigen >= 5 due to EIGEN_EMPTY_STRUCT_CTOR removal

  on_linux do
    on_arm do
      depends_on "llvm" => :build

      fails_with :gcc do
        cause "https://github.com/clab/dynet/issues/266"
      end
    end
  end

  def install
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen@3"].opt_include}/eigen3
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/xor/train_xor.cc", testpath

    system ENV.cxx, "-std=c++11", "train_xor.cc", "-I#{include}",
                    "-L#{lib}", "-ldynet", "-o", "train_xor"
    assert_match "memory allocation done", shell_output("./train_xor 2>&1")
  end
end
