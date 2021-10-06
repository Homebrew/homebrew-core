class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.181.1",
      revision: "aca255493b9672a103e1d483b48c7a98d03e2795"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c00424eadfc9a7d238c5d281cde11a0e8187e97fce75afd1993d5cca5d6a1f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "afdb5d51bd74478ffc02f3c1cb1e2d24d61081c3811ff8172236262fca64146f"
    sha256 cellar: :any_skip_relocation, catalina:      "90e9554ea0f530b6f0a382e61c8943661035b8a9b558c0478f6a0fe3eee800c9"
    sha256 cellar: :any_skip_relocation, mojave:        "dc0930ae687f4ca3379107b3e1021780cd509a3963fb464592e2f3305059f73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "857d7aa9c08d3bb6c75614cf3a209a12449eb08ac5f9ce7cbcafd697f1f4cc03"
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
