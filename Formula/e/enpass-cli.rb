class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "c53922b4a4d6df280a13605b720a52ee6a465aa831f5c666564e1912b1690c7d"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef015dbaf66347da6767f11bfdb24128482cc87b2313c5267653ad73ffd6da9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8800fa45a4b6989337e52b0b57f3c6f75664aaa01840f2f379d5b2a314d8d605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4768816d11644ab5c6a6cd64e8d97bbcfd0409a7caf06ebc213cd08c408b7835"
    sha256 cellar: :any_skip_relocation, sonoma:        "3943f4dc781997b07c503ee3833dce713003c1a6c12a3659e23f9bf11fed499b"
    sha256 cellar: :any,                 arm64_linux:   "f0aff1f75c1f1a2f573265f1df322359ee7882f5ee8748ba65074f3b73b571ea"
    sha256 cellar: :any,                 x86_64_linux:  "a4e8bba6aca520bdee33d65f17d40a09715ceaff1c28998f21df4e263d613c81"
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
