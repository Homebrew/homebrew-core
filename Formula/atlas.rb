class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.3.3.tar.gz"
  sha256 "62ceb2609c6a4ffc11e79e7497ec45e48bd9785b1dd986e1220bc3ad54d96c4e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dc3f378eb80799cb8a6322bae2f092bab2a9a13818e04b4e187a5e1a41461da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00936ff4aa6c4c2f57eb308872937257fea78c01d322f420514b91f3c3fd7d28"
    sha256 cellar: :any_skip_relocation, monterey:       "c205992849b62880fda7dc1705b93282d5a8972109e794e70a30b2b2d82c2d50"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c30645d9c429c3826026567636dba9810a20ca4fd51ab702b364cb24805365b"
    sha256 cellar: :any_skip_relocation, catalina:       "219a7749694acc669f69f60e34634806dff188a630854f86ccafdd4920f63cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24a042cac6fc1c402a89fee9873a1d56a640a5c3bf206fd7ea163742aa742d19"
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
