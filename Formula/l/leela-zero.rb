class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 11

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3089b9d144a84df5920e65998326238e54cb4132f0c8d1dd8274e80584d5d885"
    sha256 cellar: :any,                 arm64_sequoia: "8690dd5ea173e1d7bd6b91e07476f54242f598505e838e2d38fa64c90fd3058e"
    sha256 cellar: :any,                 arm64_sonoma:  "47aff2a14496f8e1f08fdad8f9318a1e1b6b4a56e57f8cd117740df41340d8cc"
    sha256 cellar: :any,                 arm64_ventura: "1647c60bb30f22c26e0ab0f3ec99d296a1a7e8bd48c4c676bfd7f469dc9c4df2"
    sha256 cellar: :any,                 sonoma:        "f6e5f5636798be24caa619d0c84d38d23c3f905e6edbb8baec7cf34dbd45dc69"
    sha256 cellar: :any,                 ventura:       "74df4fbf6d10992225a619107f28b3c583f5ba00a0f773e9609294d522c78e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2d2119742e144d26f3408deaa148a07fe926dcb7e3c735f08b6a9c7c9b1023a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb7e114a1e812141f2c633f914403e1694a962a14188d98e66757a7e48f126d2"
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
