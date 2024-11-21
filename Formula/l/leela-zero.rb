class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5c808d7abd764508dbbeda62b0f4f86cb2d117995422f872a2d6515515b46811"
    sha256 cellar: :any,                 arm64_sonoma:   "523b2b5c9a450e6a3c50f6090d8f3e82250225db54c4b75bf4c414fedc9b4397"
    sha256 cellar: :any,                 arm64_ventura:  "6d9a72e5a28e17732d5d2f5841633ee88d02a769a04056ba435e2d7b0f13e871"
    sha256 cellar: :any,                 arm64_monterey: "dca485dc625d0e8df88066c0b7d2a40342b268635123d24a385dac2c8cd738d5"
    sha256 cellar: :any,                 sonoma:         "b8bad84bb425a13306edbad05b88f13b0efbfe170f644eca3419f8052912e775"
    sha256 cellar: :any,                 ventura:        "b92d3a4331520dbb6be08f98d20a2c44d7860c02b9d87307cb971eb8ba3ea5cf"
    sha256 cellar: :any,                 monterey:       "613ece14bc664dddddd5f099a8cd2714e91b71348b47c40e920d43ea1590c77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f264275f3f12d811a7d8be26b6b8e77a7bc9bcdd0fa237e5fa8982e005f8a17"
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
