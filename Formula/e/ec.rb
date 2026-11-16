class Ec < Formula
  desc "TUI 3-way git mergetool"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "b6df932aede4c445c818c98cd58f3de08e28d3fdc0a5ed4cb964fcd54acf8779"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "baf36f25646f881c8f42c7a50fb47a300ad86bbfebc1714c708caae5a4858efb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "baf36f25646f881c8f42c7a50fb47a300ad86bbfebc1714c708caae5a4858efb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "baf36f25646f881c8f42c7a50fb47a300ad86bbfebc1714c708caae5a4858efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0843cde3acb96bd9dbedc54001268e92df34daedb7778c388c71f7d88c926b9c"
    sha256 cellar: :any,                 x86_64_linux:      "ddf4e1dc4955e542fe0c6acb7e1da9b91b51d86fc9b652d589422fe5eb9f6b30"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/ec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ec --version")

    system "git", "init", "--initial-branch=main"
    system "git", "config", "merge.tool", "ec"
    # force "theirs" merge strategy for non-interactive testing
    system "git", "config", "mergetool.ec.cmd",
           "#{bin}/ec --apply-all theirs \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\""
    system "git", "config", "mergetool.ec.trustExitCode", "true"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"
    (testpath/"test.txt").write "Foo\n"
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "foo"
    system "git", "checkout", "-b", "bar"
    (testpath/"test.txt").append_lines "Bar"
    system "git", "commit", "-m", "bar", "test.txt"
    system "git", "checkout", "main"
    (testpath/"test.txt").append_lines "Baz"
    system "git", "commit", "-m", "baz", "test.txt"
    assert_match "Merge conflict in test.txt", shell_output("git merge bar 2>&1", 1)

    # make sure ec detects conflict
    assert_empty shell_output("#{bin}/ec --check --merged test.txt", 1)

    system "git", "mergetool"
    assert_match "Foo@Bar", (testpath/"test.txt").read.gsub(/\R/, "@")
  end
end
