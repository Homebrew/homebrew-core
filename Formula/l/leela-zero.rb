class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cdc703264456e9bd15ea2737fca05a6ae6006a0ca3b55d270c3605fea9ce9aaf"
    sha256 cellar: :any,                 arm64_ventura:  "cbc43c0d598bfedec02f5e1ee6ffef5f475ba8690186f74c96dc4d97ca47806a"
    sha256 cellar: :any,                 arm64_monterey: "9b8687ce36d47eaea9d68548cebc1f01029b859e518d1438567478c81c99b59b"
    sha256 cellar: :any,                 sonoma:         "589fe8d7ea813b3292fec7304f722d7ed8ae926fe9bd72e4d5d7a19f285f0532"
    sha256 cellar: :any,                 ventura:        "741f6144419638d7443776fde1564d92b9c587c5b642dfe3fc46c1af3afde067"
    sha256 cellar: :any,                 monterey:       "ce78b3d5b43a5c8acf87e63b897021375fc686d457218bba906d86f4cdf45383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb9f74056b3250b2a08f20913374dcaf3b256355b1fbcea70f36722332f77a9"
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
