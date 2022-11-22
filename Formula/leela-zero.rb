class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7e1dc54cd88eb8411a9f232e6431c86f845769c054ef2c1b54524e927776ba72"
    sha256 cellar: :any,                 arm64_monterey: "0ac3d4c9f8ae3d5b900e4dcec2d41194503239c1867737c4d174bda8758df8f5"
    sha256 cellar: :any,                 arm64_big_sur:  "df9c877847417407625c6a3f061e715c0cccf26e3655b3726d7c70138f98b52c"
    sha256 cellar: :any,                 ventura:        "b47690e6d3db9ca801881b52f78209dec208e52f94672c580457781ad4b89c73"
    sha256 cellar: :any,                 monterey:       "8b3c96caf950feb781a366c2f7b1b770bdd1dfe814e90d2abaa2cafddefbb236"
    sha256 cellar: :any,                 big_sur:        "1ce90ee3717265c98cafc1cad1854e1787ba3cd9a02b33617706c355d3d2aeb4"
    sha256 cellar: :any,                 catalina:       "28877197dc8ab066e8f7bce53ba31326211413eb7a23c34f5bfcaecc4d9602b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53a2563f07af0a6219691c0ee2a474a0436bb392db33434242a0d21a60cd5dc2"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "ocl-icd"
    depends_on "pocl"
  end

  resource "network" do
    url "https://zero.sjeng.org/networks/00ff08ebcdc92a2554aaae815fbf5d91e8d76b9edfe82c9999427806e30eae77.gz", using: :nounzip
    sha256 "5302f23818c23e1961dff986ba00f5df5c58dc9c780ed74173402d58fdb6349c"
  end

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", "."
      bin.install "leelaz"
    end
    pkgshare.install resource("network")
  end

  test do
    system "#{bin}/leelaz", "--help"
    assert_match(/^= [A-T][0-9]+$/,
      pipe_output("#{bin}/leelaz --cpu-only --gtp -w #{pkgshare}/*.gz", "genmove b\n", 0))
  end
end
