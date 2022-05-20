class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "13e77cee07ba6d6094bfc552c3f0f34217e12a53dae301f8a1697734a69f8b7f"
    sha256 cellar: :any, arm64_big_sur:  "93db2d839cea6cd971be9192383ef281a2b561f145165f141f21714c9f52fafa"
    sha256 cellar: :any, monterey:       "f854d4a6da72d191a2db1511cd004ba8fb434a785f87a3540bf70bc45187e5ea"
    sha256 cellar: :any, big_sur:        "77af83d8aec2ae9d8e127189245fa49a66b849c4671a37aab8eb59b8ce6b278c"
    sha256 cellar: :any, catalina:       "79bb3fe211cf9cb867d70264d17cc6bdab93b9afbee02614f6d93992d151a345"
  end

  depends_on "cmake" => :build
  depends_on "boost"

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
