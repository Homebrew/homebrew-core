class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 12

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9734b50a25c17fcf027c69260fe4d315a6c85040b12e81f03acf821ffb2b876"
    sha256 cellar: :any,                 arm64_sequoia: "03d82cf9fb5a0a711725ea9e342298549ae0dcb70422957647c8a30d0e5a981b"
    sha256 cellar: :any,                 arm64_sonoma:  "ff21baba4abe3d860b5c74f18e9b19cf6296e4188bc72d693bd73c4462c481b6"
    sha256 cellar: :any,                 sonoma:        "114462e902891cc9e0817769c9ad3cbd29d865b370e2108fc9e6c8dc7d46c07b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a4d47a8070af91baa2a1e5196822a0a649697d9608769219ee56efecd9d332f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5427fd85859eb63f54b45cb31f00185eb32c7c1d7ca296dd4be832004927a07e"
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
