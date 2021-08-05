class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.174.2",
      revision: "5227ef0c245de76da6e80e0111ed303252731b8c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "698dd1d55fafb7f3b19961b6d6eb15b7d006c5652b3ff1d3187fe048b2d3f2ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab024be37e7746a0d8d96aa5117894a295fc1d7c218f8543b85da32206800852"
    sha256 cellar: :any_skip_relocation, catalina:      "7ffb93c52c842d0c9ea9e58185613aad5c7fa15cc4664745c4de023480160508"
    sha256 cellar: :any_skip_relocation, mojave:        "8b3b6e724c0a0ddf0a6b52712eb3b50317dab52b4ceda396895e2d345e029300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b0f8c6f453e62b815e185721ef6b95b15ca4618b5c47bf0ca2acc45afe48ebc"
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
