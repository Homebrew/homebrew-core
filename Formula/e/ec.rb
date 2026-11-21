class Ec < Formula
  desc "TUI 3-way git mergetool"
  homepage "https://github.com/chojs23/ec"
  url "https://github.com/chojs23/ec/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "c2d92ee339580a610a52b820fe23f2e551c010fae9ad683a2f11dba3118063ba"
  license "MIT"

  bottle do
    manifest_sha256 "6bdafe53884dafec6caeeaa934d141e1f115ac0d7a3a99c264fabc20e0769d32"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d6c441b589700d8d8a55800ff2b94e21d1c9f56882958ad5d5bba8153298b09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d6c441b589700d8d8a55800ff2b94e21d1c9f56882958ad5d5bba8153298b09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d6c441b589700d8d8a55800ff2b94e21d1c9f56882958ad5d5bba8153298b09"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c468ce3f9ae4cc97723f46db863d37cc27e6d82cbe31f855c0bbcc3341721ff0"
    sha256 cellar: :any,                 x86_64_linux:      "30c0a040274a3b54c3d1cf4a0d2404093e0cadfd6f3660f9ed8a05b054f3441e"
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
