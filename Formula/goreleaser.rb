class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.168.1",
      revision: "752d8653ffc98efec25145e1b4b802b4feed4bf1"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2eb09812c4aa96696b2543b028e5011ec2eb9f964a6fbe37a38c830df36d3f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "0cec37f2a067965eac2b83c0cada03bcabc64ec18ea2611f0367f84ca1abc8f7"
    sha256 cellar: :any_skip_relocation, catalina:      "cd7eccea5a35332081c3aebfbe80a8eab8a9c0eea3a5608ddae1964808e03ac1"
    sha256 cellar: :any_skip_relocation, mojave:        "afa664c3684ae6475c00215dba25273b3358fca1659fd5df20286b05af4b37f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "bash")
    (bash_completion/"goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "zsh")
    (zsh_completion/"_goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "fish")
    (fish_completion/"goreleaser.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
