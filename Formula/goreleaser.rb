class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.178.0",
      revision: "68ff8e996f6df76fe1cb2dfbd2a06e362c7ec5e5"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ecbe442e8754f53a24f7a35ecd23cf7c9e2dee00f10f8302402b64f24c8cae4"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd829155862fd4594b5263baac8bad780ed60fa69b82f2fe4fd19cb191fed142"
    sha256 cellar: :any_skip_relocation, catalina:      "bc090cd941ea4237c34e495588afe3c62ef9383abc65a52458d8f74e5b343555"
    sha256 cellar: :any_skip_relocation, mojave:        "465b604acf9e78497c37876bd68dcc3c7bbfead82f6f0cc91f21c22abb6e8363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9af4aada1c16e157b08f3bb06706be00dc80ac3a2bd5b29be43555ee8a692ea3"
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
