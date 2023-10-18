class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5abeab6d5315cbe33f1f4d44fa16ed4cb6da71db45cdfb5102c5f9116fc99543"
    sha256 cellar: :any,                 arm64_ventura:  "ddbffea78b40a3c37948bfd51e86087298d06147234e11afd2415b7d90d0f3dc"
    sha256 cellar: :any,                 arm64_monterey: "f734ef107e6d5c16523ae1bc807b892ddae7b692c9c538288d698dc36d57c47c"
    sha256 cellar: :any,                 arm64_big_sur:  "0c6c2bf6d9dd92e6637fe431089c9efcdc4a672a75c010848482b59ab8a08b52"
    sha256 cellar: :any,                 sonoma:         "b94aa3130f7c33fd700f6860433e4e6398a375183e6aa5d4ce55beea7c581f9c"
    sha256 cellar: :any,                 ventura:        "fec16c9e60dfabf87969cbc54fdc234d352d71501048110039b4ce9a34d9a35c"
    sha256 cellar: :any,                 monterey:       "7301489a06ca98bf2c214b3266a37089dee980bd11409125ca8a59aac1730839"
    sha256 cellar: :any,                 big_sur:        "de294e82925db4e06a028b29b04aba9bd9724a7924a2b062ab2a766ef4a77c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22d6b86dbe066b256131fbdb074ff4e9bde8ecc710b25d80d2a5253998a4d6cd"
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
