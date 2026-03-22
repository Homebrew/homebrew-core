class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "9880a54d3364aa2b6f51dffcbc54954ab5c23258d9c853cb322df0eaf1f18c09"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ce36f144f8e8a9d5a1623cb2da4249f8299fa753f05deedf435c2060631205f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19bcb8483cc1c6e38bb63d810655e9a1afdaf9551821e70eb2300d0539dc4dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a20ff3d1d80f7252e9ad0f9f792c72a761a8d0057975dfc866b60e9003c24791"
    sha256 cellar: :any_skip_relocation, sonoma:        "638c10edcff1b0ec6198d13bd117c474f655ab3a568999069141f3b575a955e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bba60eb71ac340fa99101d3bbd73c307876159d2071a8270a44ef7e167a51d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f1d4c5edd81420f6148dbc1a9177bb9b79ad4c1516292a01928dc9d426781bb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=#{version}'"), "./cmd/enpasscli"
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
