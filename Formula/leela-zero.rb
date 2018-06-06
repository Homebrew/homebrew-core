class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      :tag      => "v0.17",
      :revision => "3f297889563bcbec671982c655996ccff63fa253"

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
