class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.176.0",
      revision: "dd5ccf7170741e0303e90e81faf9073d03ac8f43"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "861248da00095ebefae40125bd0473b2dc1541a1a5aa74dfc388acc349f3a27a"
    sha256 cellar: :any_skip_relocation, big_sur:       "676f8a8f59881a3fc4f09f77c2f4003abddb6ad3fee4bdc308dcfdfcc758db1e"
    sha256 cellar: :any_skip_relocation, catalina:      "4f14162df53b94760c00d03f490c5588a3b3db95469241e597e8ab2ffd4b4fb3"
    sha256 cellar: :any_skip_relocation, mojave:        "c01061381fe64f61deeca72a3be72b8d8f21d50aae9f423dd43ae53c53742ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92929245d532edc9a13fe8ecb9633afbecbd76dd888ce1a2ac581610b8d363f4"
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
