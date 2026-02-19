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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8ccf615e92183ab7d8f06a8148e89ebe79c45e0f3e12ba4c845d15ec9492542d"
    sha256 cellar: :any,                 arm64_sequoia: "d7d8ddd70a07c331aa0900ba316bfc2f21bb3793ea72784bcf7df910feac651d"
    sha256 cellar: :any,                 arm64_sonoma:  "16214ba1b05b5cb5854f2f4bd38e5bc0e1af03eb07e6bbd42eb9d4ddaf98ef65"
    sha256 cellar: :any,                 sonoma:        "9b671b74931247c299cc35f74154b3e433aab14ce3beecbbbe61ef4bd2694435"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8118f4939edb749336936eea44f839b8960cdeded29190c8fbbe9dbccf65824d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30aeb411b41c6d336ee9a21bb7c34613d6a04135993b177ed398a8395e2161df"
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
