class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.163.1",
      revision: "e7f1ec0ea605c6203ab049565de06ce1e5217458"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4de1ef7761f8754920f6d6f65211da3d932ecf45d68c7d6aa326fd62fc9a622c"
    sha256 cellar: :any_skip_relocation, big_sur:       "287b1ef4ae9c2b0f1d21fc3720e22ead68c8cd0efa32520f6d2365984e3043ed"
    sha256 cellar: :any_skip_relocation, catalina:      "4ec738a2b7cec6f12e76d0bc5385f84e1d495520e9accc9dc94f31b45d4369a9"
    sha256 cellar: :any_skip_relocation, mojave:        "a79dd80ded1c714fab421964673b5e1a4c73e9073a38094f095ead845379842d"
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
