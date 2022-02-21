class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.3.5.tar.gz"
  sha256 "005c0108fc92355a7a7c9df98dd18062a3575e970a5aa992d7a0a731a451b49c"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4516fe2ad1b9f5fc24e35f5b5b2cac7a2c13e77dfaacef3910c058b3b9efa9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e73d464992882423778659525dcdcc69c670624cd9140b90d43d25a90464414"
    sha256 cellar: :any_skip_relocation, monterey:       "65407105999de1812a94cb41a2be15a268479d3f733024df16583eba5388b2b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a766d10b5a1e328caad4075c73500ec401ab36171300b4450acb4227fbcd87ab"
    sha256 cellar: :any_skip_relocation, catalina:       "5a0d8544c538d776548e7640721ac6cdfaf83f2897373f606ea566f6cfdb8f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac012ccdc01e92e54e61fe2ecfb60c78c64dee5e7afda89afce1914108528b94"
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
