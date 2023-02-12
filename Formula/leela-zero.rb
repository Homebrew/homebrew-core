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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a2cea179342feeef69bcba2c3847537bcbb06f39fe9f57daf37fdc1db750b553"
    sha256 cellar: :any,                 arm64_monterey: "1dfe58094c24f53de3184f6b0ff7e276c8550f6f6804fdd30f5ce7fae008f677"
    sha256 cellar: :any,                 arm64_big_sur:  "07e20dcf3b4eed4c38695195223573bb1b8806128012efb0c35f4caea3c81583"
    sha256 cellar: :any,                 ventura:        "070c0e1232c06b91780517aeb80b211c1eabf84e86aa3cf258c1b21d2224f605"
    sha256 cellar: :any,                 monterey:       "1a9c5a5278fc1e6db6c2a28d025ebac0d7a270f94ebb18f70d2cb52ed5d980a3"
    sha256 cellar: :any,                 big_sur:        "19ff119dc5abaf06a83d2d8bedb8aa82e617d612d966e6dcce4121fb592b7013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3703311c90cc9ef62c0f711592630f683c81a3fd9f4bd0cef087734684548b2d"
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
