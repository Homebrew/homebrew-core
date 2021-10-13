class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.181.1",
      revision: "aca255493b9672a103e1d483b48c7a98d03e2795"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bcc856ac601cf019f63c88ea0a46a7a6792933dbf6a7b61d33de7d252efe1831"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ad1d30329fe082f77718c6a2e5a3cf63206fb505b165745679f44d5a3fadb53"
    sha256 cellar: :any_skip_relocation, catalina:      "e0819b3f339736d11ff8b1c8038f0c7bd104d6e65802088f42726a23ac0c9d74"
    sha256 cellar: :any_skip_relocation, mojave:        "c415f7373fbfebb201a22a687cba3c1ce0496962d539a7932c38838ab0c22ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ce3e808c29f416fd9b8268491f71713b86b78ef8d8eab34c4634bbf3f7619ab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

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
