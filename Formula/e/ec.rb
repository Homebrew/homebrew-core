class Ec < Formula
  desc "TUI 3-way git mergetool"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "bfd7017c09b395df73850b72d7b27f026fb6001b2ac165097f7c3d7cebf23534"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "282fe3cad8025db72fad98fb305dc599e2b38836c5f5f84e934e927547bb1665"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "282fe3cad8025db72fad98fb305dc599e2b38836c5f5f84e934e927547bb1665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "282fe3cad8025db72fad98fb305dc599e2b38836c5f5f84e934e927547bb1665"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "107397e248483445a682084b861b8795e3202d3f1b05518ac200d3f9ab4ba6cb"
    sha256 cellar: :any,                 x86_64_linux:      "cfbc752b3fb81d4f609055509853cc4cea6a1279acd66e0731ee29688ccb9037"
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
