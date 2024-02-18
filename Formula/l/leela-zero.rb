class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f4956ccec1b85d940dc51c3cff6ca243f5684490b7f44f5d65263d6ea965a30"
    sha256 cellar: :any,                 arm64_ventura:  "1ec17a7b79425e00c7213878e04ed3af8eb826bf441be5a862459a02a5dbf110"
    sha256 cellar: :any,                 arm64_monterey: "9a2f5da8ea704a711ae8192758a61af7958b7342d4e9e46d74558e1d8593f63d"
    sha256 cellar: :any,                 sonoma:         "e465db7030e99d3c357544aeaf9fa45615e12ee939532c925d1badc444f2e6b7"
    sha256 cellar: :any,                 ventura:        "b83f1b99f4c1361ae1104b59205cc927b3b0be09b070a08400ca86852c9cb03f"
    sha256 cellar: :any,                 monterey:       "42584c147e4925d5e46d115c723146feb09cc16f4b8177ddfc0cde58e3cf9ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff4fabe6cafc541960ff787819a42bfa73d2dcbcfea590938fc0164487668978"
  end

  depends_on "cmake" => :build
  depends_on "boost"

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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
