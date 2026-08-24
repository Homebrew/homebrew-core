class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 13

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ebcec12f4bf9ac5f08ca649e1f5c747ac6ed9fd566191a6f923a2a508008eab7"
    sha256 cellar: :any, arm64_sequoia: "85999bd9485c5c3618a012f08e3158a9d47b26d51feeb771bfb97f101c250d9f"
    sha256 cellar: :any, arm64_sonoma:  "a70f5e723931265b9e002844bbed6c5ffd59c6899a64c2500a2433eefd700219"
    sha256 cellar: :any, sonoma:        "751ba35825b65bcfac431f9ecd3436a721839c4036049c5933107f7dda4974a0"
    sha256 cellar: :any, arm64_linux:   "3ae95483113aeee4955c35c7caa73d751ca9187aee9415f9c4f1d0a074de779b"
    sha256 cellar: :any, x86_64_linux:  "d77992e2eb3982eb5026ca9987202627af13e2ceb3b490d1aece28cd8d6409ff"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
    depends_on "zlib-ng-compat"
  end

  resource "network" do
    url "https://leela.online-go.com/networks/00ff08ebcdc92a2554aaae815fbf5d91e8d76b9edfe82c9999427806e30eae77.gz", using: :nounzip
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
