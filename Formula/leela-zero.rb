class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "f3cfeaf311cd1715bf4d7b7045e489e9c35c5dd3a9d4eed2abe27f696564dd80"
    sha256 cellar: :any,                 arm64_monterey: "3416764fa7047342ff9a7972e4e22aef964f00d20df18f754f45c36a4f95f6ff"
    sha256 cellar: :any,                 arm64_big_sur:  "c7dac38a5dbd96d2581a6b3ef6abb2cf4cf1dc2ac9bf4817bbaed93d84e52af8"
    sha256 cellar: :any,                 ventura:        "c0a94fee58b9250b31479a1bc6a6dc8ed39df132500e1e52427dac3f22d78a66"
    sha256 cellar: :any,                 monterey:       "4aafab60cf165569f6062866a9ed6385177d976d4fb9869f8cc3b8c09b7f5c00"
    sha256 cellar: :any,                 big_sur:        "c488bd8ecb4ef01d1237de4048a99466ce946cb0afd98e1b5363dd779111555b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ae871d017708d7663f1957bc120bf474fca14332e543f99625ce730478fdae"
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
