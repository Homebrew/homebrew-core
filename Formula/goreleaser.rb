class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.5.0",
      revision: "55d7eabc79d41e073cc4592c350c1f4c7f527eb3"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff46b1553a0e66739cbc7f3d48fc57ab35944de9237113933a0a8ea90b0cdc53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75b365eb47d8fed4fddb83e03e1e42a9aeb792fde476aabb8b878f972f4d7a2d"
    sha256 cellar: :any_skip_relocation, monterey:       "43ec3ec351c52ed18c5f8f5a11e5b3526c3f98a8b4369a1fad034a860026fbec"
    sha256 cellar: :any_skip_relocation, big_sur:        "32fe4beddcd290f6b0c3b207f2965a68cdf147376d45575a14a9bc11e4eea0fd"
    sha256 cellar: :any_skip_relocation, catalina:       "64e1039f65140784808fab7a475a204c4ad00376a731761bf9a959c54acf3f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a046362f0c528cafb1865657ae926d5a31380fad899a9bc2afd81f389661f0c8"
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
