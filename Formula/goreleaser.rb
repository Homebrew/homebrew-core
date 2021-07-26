class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.174.0",
      revision: "1dd2ad1ae6c509c01bb598e1698686ac2ae6557c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e614d3181eefcafa59ed0ffcf284eb6a0167aa8d3093f174d2c0898a97714917"
    sha256 cellar: :any_skip_relocation, big_sur:       "57f04caf7f03244520160f6523d651ebf286a121f37039d6b5a1c5741f17c79f"
    sha256 cellar: :any_skip_relocation, catalina:      "59d336f7b3ecfb31c588ec8ca68da2dd36042bf5cbe1276a44e6434b0036b120"
    sha256 cellar: :any_skip_relocation, mojave:        "51322565423f29f601cd5db88a3fa3204e32e9b73825e792efa135099593cd31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb6e7fd630389679efe463d613254dd1fa14593660504a4495217308dd8b42ae"
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
