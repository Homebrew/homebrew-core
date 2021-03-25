class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.161.1",
      revision: "00bf7455340c3b6dcba7c02fef3839b0778ea18f"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56fba65ad62e896b96aacdc2f0fb7f35273082510c67c26d717ecc2f2366c909"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc9668ad74e5c0237ac6af9d83751b1d021cb5061387f776e72fa2815c044fbd"
    sha256 cellar: :any_skip_relocation, catalina:      "b1659b25c51d6527b7c3da875d1fc683a2aa4d0e1a647f384bf167aa035ffc97"
    sha256 cellar: :any_skip_relocation, mojave:        "cab6f8f811b1b38ea838f45a2ccf3087d2af143f10a654b78b90747a93c41d91"
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
