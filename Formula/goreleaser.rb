class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.173.2",
      revision: "5bcfa9042d0efd419b660a3b63c815a13d919e30"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed6ea8b096f91650028f2ef4ea1c27eb46bf36af5c0cf80b2158e1caf1bbe883"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0e8002a177f31a44f8e16dde66497961d0a9a139c6a30fc2fac92fd90087c96"
    sha256 cellar: :any_skip_relocation, catalina:      "41785bdd07bb04eebb6a2ad7c07777ca3f178912c497bb1ecbbc683451718951"
    sha256 cellar: :any_skip_relocation, mojave:        "40d2b3e971159c8774a4d93190bc91ec8bea5912ca9a3f66183bb2bcaa955934"
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
