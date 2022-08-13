class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.6.0.tar.gz"
  sha256 "9ef56be848c46aa816fcbc5bc9c0a3d4429a8a41e30d0b5f80e07c867cb82796"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99e7bdbbec9c52ae0d03541d9888f527502647f36d335317a5fdaaa802eee936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf31ca60f92754234154bd4ed87efb50f72d2593c0d27c35705f0cd610d285ef"
    sha256 cellar: :any_skip_relocation, monterey:       "cce1af44145fe5917bc237d8030a76e47fb92aae5ebb147540b1ac67d892bf43"
    sha256 cellar: :any_skip_relocation, big_sur:        "6075e3038947ad8efa3fd8bcb87ac180c60314a1e4dc7bdd51e85e932c7bda8b"
    sha256 cellar: :any_skip_relocation, catalina:       "0a390cd6b1035c84e70bb0d9a961fa6d0c11e7099bc6c5c9d834c7763746206b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da366802952d6b41cbb47e8016c46cb24861fbe409bc40fbbbc3352d130a3477"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    bash_output = Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (bash_completion/"atlas").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
    (zsh_completion/"_atlas").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (fish_completion/"atlas.fish").write fish_output
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
