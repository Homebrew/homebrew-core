class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89c9cd32fe6c7a9c5239fd79cb4478b59c3fab520ef41b6eac2420c549d485c2"
    sha256 cellar: :any,                 arm64_sonoma:  "d53fa2be94dea4d05c53dec8fe788b9d0592ba2fe9a1859f469a3561514b0503"
    sha256 cellar: :any,                 arm64_ventura: "6be25e10e1be034a3b7aef791fba5d45e1b288c818035b997a9d26f0742ef463"
    sha256 cellar: :any,                 sonoma:        "0a10d9190312af4f6f6469d57163a463cd99f52fc16100f6c145a107001e1a5e"
    sha256 cellar: :any,                 ventura:       "da90734e4217838d1e9ccb08df23b9d841eea2f5daf3107e17a45a1af8e4db8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75cf01a629f8eeecf1e21f43b6ed281aad1ab5bd434fbd25e762c2ee1ff6e47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5ee03297c6c74f7bc78ed0ce6f77a798720c27e099f2949b855db92dac4086"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  uses_from_macos "zlib"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  resource "network" do
    url "https://zero.sjeng.org/networks/00ff08ebcdc92a2554aaae815fbf5d91e8d76b9edfe82c9999427806e30eae77.gz", using: :nounzip
    sha256 "5302f23818c23e1961dff986ba00f5df5c58dc9c780ed74173402d58fdb6349c"
  end

  def install
    # Workaround as upstream targets C++14 for older distros but Boost.Spirit 1.88.0 needs C++17 std::optional
    # https://github.com/leela-zero/leela-zero/blob/next/CONTRIBUTING.md#upgrading-dependencies
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 14)", "set(CMAKE_CXX_STANDARD 17)"
    ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION" if ENV.compiler == :clang

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install resource("network")
  end

  test do
    system bin/"leelaz", "--help"
    assert_match(/^= [A-T][0-9]+$/,
      pipe_output("#{bin}/leelaz --cpu-only --gtp -w #{pkgshare}/*.gz", "genmove b\n", 0))
  end
end
