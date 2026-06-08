class Ec < Formula
  desc "TUI 3-way git mergetool"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "348d264be5380b909fbe49b145ad882f479c17ef9babbcf753b80c2b8ffb643e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "807432832f53e054c38b5d2e446e1ad688c6e9289a488722410f6c774be53e21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "807432832f53e054c38b5d2e446e1ad688c6e9289a488722410f6c774be53e21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "807432832f53e054c38b5d2e446e1ad688c6e9289a488722410f6c774be53e21"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9efcfbfe86f35c81103e8a66ce69dd66c90864054a1ed4028df0ff8b8a21d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ff9dcf9590448451f9644f468f051e4eef7cf824df069ed6c75ce1f734563d8"
    sha256 cellar: :any,                 x86_64_linux:  "c16072a254b0667c4796eba5697815b0ec7400a0e5fc81f841e377f6562072a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ec"
  end

  test do
    system "git", "config", "--global", "init.defaultBranch", "main"
    system "git", "init"
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
