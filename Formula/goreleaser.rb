class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.161.0",
      revision: "d04a7dad19245feedd07686bc073cdc394da38c1"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7cd5063b456ee91bc76c1bf74bb4d300bdd08d0456959823f246e5d9aa962a04"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ad6a5f3eb54419b414c9341a2f75dbf85af92f0a42fbbf0d8d480b944e8e842"
    sha256 cellar: :any_skip_relocation, catalina:      "876caf1ab0e89c0a8734a394a2a55218f5b43f6ca91e6500fae17926a0607b48"
    sha256 cellar: :any_skip_relocation, mojave:        "c6115cc292fda914c22f15cc6fd989b36cb55902b510c98b570daada47b403cb"
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
