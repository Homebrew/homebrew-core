class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "61e12a8fe0e8fe63e625c392e6b137472aaaf25442ec17801926a9c8864dacee"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7d4bdf3638de52bd32947c04cd85ff0b0a6bc674903af2c2c3f241c7bb65ce2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49e00953e2cf900d3aa7a0e27e780531fe92c977bc4f18568d55bb4c5f7cba9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9af0f566e7116e4959dbfefdad90c9b742cfccc91ed339c63d251c290ace9161"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "016a23188e3a91d2d610d7facd68dbeef231fd5bffd539767001aa838197ba22"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc2211e8c932c6393e170e0fdb1b54f36cb6624b33f085c74cfd0d775a64e1bc"
    sha256 cellar: :any_skip_relocation, ventura:        "bf35c63e597769e692d2b07f02baf1e8a8c7c9ee6764eaf1f9e9ec83dfbe82f9"
    sha256 cellar: :any_skip_relocation, monterey:       "296e43fe575b535509e2882a50084ae0cd31a7d0d21cb34335db59865af225e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e71daaebd21ea06d5d28adba17a70bbe0f9968b9bd9518c24266bea9537c859d"
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
