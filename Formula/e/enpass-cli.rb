class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "674d0ec15481703962eff2aa69e243ae2cd003048f862344bf925c28d7ed8f3f"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f5bc5117b499b0d5a3c37542d5c810597dc3ed5243ebdb0f6b2d575209bbf81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e2d55619788054a43e3058efdaf3db60c7fa979c77bb1e73935c6cd55dc1a2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abb8245a4ac77d1990d1949043c2d1b8baf0162d03814ca0b81c29ae7851c889"
    sha256 cellar: :any,                 arm64_linux:       "9a33794d9d1c440aea0a457d87a25bb76575b3c0f1886359a90e9ca51f0394e5"
    sha256 cellar: :any,                 x86_64_linux:      "ca7f359344c4f97e6e7f27d798bfa464296b581c78cf5f3aef779b049294578f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X 'main.version=#{version}'"), "./cmd/enpasscli"
    pkgshare.install "test/vault.json", "test/vault.enpassdb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/enpass-cli version 2>&1")

    # Get test vault files
    mkdir "testvault"
    cp [pkgshare/"vault.json", pkgshare/"vault.enpassdb"], "testvault"
    # Master password for test vault
    ENV["MASTERPW"] = "absolutely-No-clue"
    # Retrieve password for "johndoe" from test vault
    assert_match "noIdeaata11", shell_output("#{bin}/enpass-cli -vault testvault/ pass johndoe").chomp
  end
end
