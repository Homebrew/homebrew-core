class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "7b043c26b64dde66344d144fbcac3664858a4eb32197793ea2a18feb32741ca1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b8f359d1c96cff36ff195483555db0a922dd6e6226010ea213e633acb92dd202"
    sha256 cellar: :any, arm64_sequoia: "57b1dc6d57b3d5b16a13c63c45581c7890dc28a79b8a53f41f1bd2745925da9e"
    sha256 cellar: :any, arm64_sonoma:  "52cffc7794f9601ab6d147c089682bc0c1fc2d9047297607cfe13e4d50fa9370"
    sha256 cellar: :any, sonoma:        "ac08f76257e2d6ee93b5cfdf3f631986952cf81d2e6f48144c4c8186cd612a30"
    sha256 cellar: :any, arm64_linux:   "a98183457bfe0e7913bff0e5aa295a8412c5b98cd182d08cb9348a0838712df0"
    sha256 cellar: :any, x86_64_linux:  "25ce85ecda8ad304f7f7353e39fc9b99cee9a2869e89d68b6c8c37265819a060"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/pages\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end
