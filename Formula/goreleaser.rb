class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.10.3",
      revision: "315935aedc9908b078ae525b33ddb42b2fafcc54"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96ed9c02dc182a8610baf9c5a195c44857e4114ce46f33b67336bf991b4805ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47285c7d0fbe5ce4d5ad013dca3916ee282354219f12220c2c5bb18bba61e5ec"
    sha256 cellar: :any_skip_relocation, monterey:       "81380d0512203530e81b40dcbfaed3d322882916d613c26be348f4790fe4ef6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5118b2e621058c80b89a6d10e1b4962eb67a237e2396b15393ac6d895e56631c"
    sha256 cellar: :any_skip_relocation, catalina:       "5703803179ab2cd1702bea11fd03ea790e2d8eab9bd7a9c5e7043c79808d9890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b8a69bb9c62437bfe8cb35ce294641b09157baf41b84655669b2cbfa0896800"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

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
