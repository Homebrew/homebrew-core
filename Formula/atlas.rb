class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.6.0.tar.gz"
  sha256 "9ef56be848c46aa816fcbc5bc9c0a3d4429a8a41e30d0b5f80e07c867cb82796"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7a15df2604c69878af0a5ee6504d6971ffb90cb5ead8d54946fdf786c71ae48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b4f8c0e939f16fa655ba99428e8f50703c556bfb54662c1de1c8e0e48695d27"
    sha256 cellar: :any_skip_relocation, monterey:       "57e595d7a7d033601cd706d4b1ec7ae03a60d7efcabf7b035cae9f70f52b78a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1a5bbead2d2a49ec2abed3bc10c7a63528b2e6fd613b4cf4391818f3e066dba"
    sha256 cellar: :any_skip_relocation, catalina:       "3398b2e59bc7ff7f5b268300461f34c5645a5786865610ec9540c229a0e8e3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05b39d9e4bb1c3ed39551125895d434639aeee25fe074d6d84d75a0f2ec16a00"
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
