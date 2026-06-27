class Ec < Formula
  desc "TUI 3-way git mergetool"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "9598d57cd71c35c057ce92fda690380e3a138b44404ef14cbedf9f577772b71b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a43dff355d32cd7d40cb11c1483ee1fc01ee4a88b0ea45f7a9298a313ece8548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a43dff355d32cd7d40cb11c1483ee1fc01ee4a88b0ea45f7a9298a313ece8548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43dff355d32cd7d40cb11c1483ee1fc01ee4a88b0ea45f7a9298a313ece8548"
    sha256 cellar: :any_skip_relocation, sonoma:        "de3be0619797e0575512802fa496cb3ee78dfdcf7a0706c4e9f5b035ef299b2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02018e408c69c3a4fa65c3f9d952e7a7e6122098ec82f9d754308583aaa6ade0"
    sha256 cellar: :any,                 x86_64_linux:  "8072200a975fbf9ecd984f791d9bcf29630b32cdd3adca8bd05a6ad91fa09150"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/ec"
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
