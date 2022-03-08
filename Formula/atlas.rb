class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.3.7.tar.gz"
  sha256 "e958e6e31cf7f04f082939322875165d38685e1a2f59334733dd47c44c19b747"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eed4bc6c5f3feb77e7418b226de83a65de552a357575cb01ab5694cd383fa0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "586520c4cd1b5fef5dd3b303a28db3fb5b7a18f7d4c11dd2d458dafc7cb0876f"
    sha256 cellar: :any_skip_relocation, monterey:       "f09196071bec3303a4f70d12c728b05e1419921dbfe5330c6087a47fe8f67b45"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e3d8f12bffbd62192607bfe8c2c6d72e088029555d246aafede105087e381bc"
    sha256 cellar: :any_skip_relocation, catalina:       "7e431d5b913036492241df603d3dc89dd03180bfa2d94eeb690a773338e49ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a318452852655cab9aaa051007485885204ef9d572405beeaa541c371ac37a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/action.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/atlas"

    bash_output = Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (bash_completion/"atlas").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
    (zsh_completion/"_atlas").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (fish_completion/"atlas.fish").write fish_output
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -d \"mysql://user:pass@tcp(localhost:3306)/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
