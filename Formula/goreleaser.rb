class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.182.1",
      revision: "d5638991c81f81b1757b24c740b58344efb2dbc0"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bdb4d877aa63ff4415127e7995b4d5ad1f1c5a3b04cba4aa889bf0ec03e30279"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4d66de29e1bb32a5c3aa789274563aa455d9a264f07411a7832fc522af81e5a"
    sha256 cellar: :any_skip_relocation, catalina:      "9b1d218cf79925d892a27b0a3417f09f488373441f2b968fbd9d5af0d61b729c"
    sha256 cellar: :any_skip_relocation, mojave:        "50bcb6c01997587da2e1bbc6c18d50d9eb1d204bb7baf9ca7e59d475bf190448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e58b3294c3606c693303735fb7ec16e2ed7157db8163b20815bb1a88604746f"
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
