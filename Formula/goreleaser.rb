class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.180.2",
      revision: "c90f1085f255d0af0b055160bfff5ee40f47af79"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fcf214e0a38641d6db6052ac95783f245433deb5075c4ffa763a30836ddb26bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a0571e4cbc29014df0b3eb46d7f61c4e56c1b218b28c09ff5fd79cb7023aaad"
    sha256 cellar: :any_skip_relocation, catalina:      "fc90857250deff0ac9945943f1bc20337827943918af3347e899f4cf59f01935"
    sha256 cellar: :any_skip_relocation, mojave:        "dfc506524151f8f4a6b866daaffaa1652e39c7f5ac35336cb7f89872212109ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "542ca3fdab51317d3e5e7164435480bb4e77ffa4c72fb754c50699711c7580ae"
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
