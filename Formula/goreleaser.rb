class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.0.0",
      revision: "4bd0b73e95e83cfaa51b19330c4b039d1d7c0d09"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c78d7f4614d86f7b886e1a8dbd69b8afea89e0feee012e325cd045dcee21037"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03b40130c68667cf2881a1afb051a4a120373d5937301d5299d2e7e87574484a"
    sha256 cellar: :any_skip_relocation, monterey:       "fb875c82ee4570244dc76b75822f9398cefafd306cbf39f407a672e7a46db32d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bcf2b4a9329ab49f1b4145e59b30265b423028e51251745100952fa5a544345"
    sha256 cellar: :any_skip_relocation, catalina:       "c44ecd50d1c4f1d7e0377e03c73fc57407f2629fa1be5ed56e9f342b8212d52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b057cdf5d44e00b58b11f9913a058c4f2c4c9e938eab6cca332685c0267b0d2"
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
