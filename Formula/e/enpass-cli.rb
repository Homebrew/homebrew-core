class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "674d0ec15481703962eff2aa69e243ae2cd003048f862344bf925c28d7ed8f3f"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a375d30cafba65e9b79703aa433917a784b0ac61366516c1ce0babfaf81c3914"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02d53ac1384605a8a36ab338f0af5ce36f43f4fcae82e99f27da398ea71ebecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e18c6896fda816a53d59f48739a134d37931cc1bcf58447ae720f30e57a025c"
    sha256 cellar: :any,                 arm64_linux:       "19224a412234e9d7fe0c51bb167d44997def39d0bd6b442ce9c687548e78ed91"
    sha256 cellar: :any,                 x86_64_linux:      "cd21525870632503bcbc274b4c3b33da20eb4c107bd2c624121361ce2fd7be64"
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
