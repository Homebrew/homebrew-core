class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.3.1",
      revision: "a6a6e11cc9d40a2b9d48fb7331d35ecce1f39a71"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad9faa45761806209c20b018119c0419c2a32dc204ae556f9ec4fe3e5f2458d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c53bd53067aed6399307a114e24ab7be5612a0a968829e6b133ef8b8398685c"
    sha256 cellar: :any_skip_relocation, monterey:       "88d62c8ceb647c8021b16fea129a074c5800ebf102df8255c9e52e91fa5c150f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3d53fed19e7c62191a54996ae87ca41f7bfebc5cbd125de904efe78879b56ae"
    sha256 cellar: :any_skip_relocation, catalina:       "3b4fb4611142f4ca9a0475692c7be114be4761d6293f86fca892a9c02a55e9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49400c69fa341ff14205aa6aa1b151df27d0733d597deebea0b1196a180e2d7d"
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
