class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      :tag      => "v0.17",
      :revision => "3f297889563bcbec671982c655996ccff63fa253"

  bottle do
    cellar :any
    sha256 "b9764e2ebdade7c55ffb44f29f3c546be8003348ecca7b6ea0e93969cdce9032" => :catalina
    sha256 "6e95d7ef2f671bc404fcafd426b47cf3c4c9a9f2ab577772c03a1cf721a20444" => :mojave
    sha256 "ddb11b34f4a1e210e52ad13c4e789b2f0958278fe3cadfc94dc22afcce59bfa4" => :high_sierra
    sha256 "decf1639a96bb4fd9a198f74f7c20413cde1109d913769f0a32cc2a6c9527778" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"

  resource "network" do
    url "https://zero.sjeng.org/networks/00ff08ebcdc92a2554aaae815fbf5d91e8d76b9edfe82c9999427806e30eae77.gz", :using => :nounzip
    sha256 "5302f23818c23e1961dff986ba00f5df5c58dc9c780ed74173402d58fdb6349c"
  end

  def install
    mkdir "build"
    cd "build" do
      system "cmake", ".."
      system "cmake", "--build", "."
      bin.install "leelaz"
    end
    pkgshare.install resource("network")
  end

  test do
    system "#{bin}/leelaz", "--help"
    assert_match /^= [A-T][0-9]+$/, pipe_output("#{bin}/leelaz --cpu-only --gtp -w #{pkgshare}/*.gz", "genmove b\n", 0)
  end
end
