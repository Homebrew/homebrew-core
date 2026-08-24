class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.16.0.tar.gz"
  sha256 "162d5b510518ee5f285f82fa1f16402a885176e818bf1b1a4c3c91c9a2f01eae"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ab14bee159d7d6ebaa31b25db60880d8f2d5c9f8fa259ed93482dcec27d5e94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96a37748eef828d887209d70d0634e84c5f956d32d869a659e70e33a576cc245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "689c0523b4592ebd73310bb72b8fc6211e907c9857457cb201de3d5d17781527"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cc873a9338bacafd8b4219b9aa08dd73a47a08194877918f8b327324c284195"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d80a9952b57de6a68b429478926a6651992a3e24e0647f56775ee6337b0f06a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b38e74277f956f35a965a7eaef455c331a08ed0f299006861375c5b8a7b398dc"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3"

  def install
    args = %W[
      -DOQS_USE_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/example_kem.c", "test.c"
    system ENV.cc, "test.c",
                  "-I#{Formula["openssl@3"].include}", "-I#{include}",
                  "-L#{Formula["openssl@3"].lib}", "-L#{lib}",
                  "-loqs", "-lssl", "-lcrypto", "-o", "test"
    assert_match "operations completed", shell_output("./test")
  end
end
