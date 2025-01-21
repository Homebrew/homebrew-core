class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "4273643dbcc5ec25484e393c14fd03e4749868703fc1d3d966e95016637ebd1c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e4bb4eca93771641aa5af5d562a2f88883313b203cf6ff69e18d3610c7ba89a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "802e931a6228902f349387995daec38d6b37fb8a60b880a4114ee1f6a58cf22e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c93e36fb9b79d4d6fcd30dc57ebd0c5a01510bc2175a4c571ca7d960821e2377"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3d926b3f31458734e2641c59768fe04ba5861e69a3b2ac250eab546a1c0db15"
    sha256 cellar: :any_skip_relocation, ventura:       "e1b8aa67e57770ea8e9f6deff9e2007c2e4ea7439829d41bec415f2a4e3737b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "817acec694ab6288bfe5b56d89ea7a13dff84d3cfa35aef0c764f10bdb4f0a9a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/issue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}/evtx_dump #{pkgshare}/samples/issue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}/evtx_dump --version")
  end
end
