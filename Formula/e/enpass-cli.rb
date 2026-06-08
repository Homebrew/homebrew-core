class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "a211566965a4737d41ca5473d096df996a63ce53e45c22957db816f6d4b57ec4"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4e2704fcbfa4cc85861b1a5ac098718b53965ab52a88f6cee6416da86c19d7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "544cfbc95aaa30fd64c03e51b22f026c1038e0111b8de58c2bd613348a895b87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b778119d188192b1b22d2b484aa0a23cfe24ac1f36910cffc3433575b1eff9f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c0be98b3035769c5da7455c479f97fe1fcb881232f3500fec6f8a58fe08ece"
    sha256 cellar: :any,                 arm64_linux:   "c5a65335a9f9b2766e2590369ef7298e315bfb12e8bc18f78552bd816fd368c7"
    sha256 cellar: :any,                 x86_64_linux:  "cc76815817915195cdb40938d45d2e86cd3f3ea28316d33326e6c6ccad00cbcd"
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
