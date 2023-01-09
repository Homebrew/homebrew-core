class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0f2c0c4a069b613bf9c685447bead6375f71ccb9737800049b3bac3ef8b00525"
    sha256 cellar: :any,                 arm64_monterey: "6774b93733d09000e1dee96c30121bdd33727734bad3a9d622d7f0e918a26c87"
    sha256 cellar: :any,                 arm64_big_sur:  "06ae17d8ad3475b1deecee730a1b016eea91aa223267105fa925c708f4d30576"
    sha256 cellar: :any,                 ventura:        "def45059b0e71028374487e27b2f540218ff9057b79a351b31a53d609f989d18"
    sha256 cellar: :any,                 monterey:       "69f9f6e60bb36b5d1eabbdc33d58c4772d37dfe4c6e17e4f3745569292153b6b"
    sha256 cellar: :any,                 big_sur:        "ab3c6444d9b61cfef71f3055e93716e7ec3c7af5315766b9ff1f6be5239289a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23edd4fefe24d94423a93561c2055dc06f0ab0322b9658abac34b6e1c33dc44f"
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
