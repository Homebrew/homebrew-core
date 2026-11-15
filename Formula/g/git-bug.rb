class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/git-bug/git-bug"
  url "https://github.com/git-bug/git-bug/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "d02f75b5ca4a6ab7d8cd0bf028cee8f090ccd7f07854b5edeb4953957b75e39a"
  license "GPL-3.0-or-later"
  head "https://github.com/git-bug/git-bug.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e030ba13cb1a832795785efc0b6aa180530c2d9b223e47ebfc0fcc7195fbcab6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "422c8a3590a58d4e50518c57bc5b5eb7b96dca2a96c77f54d4d5d3403dce2a7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6eb59604588504f3af487aef7d0de8d02dc45f0747600c762371d7d99673f793"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16d19bda2b72100b1b41c39250467961fb282b76b14e841efe7e813f8a42e2b4"
    sha256 cellar: :any,                 x86_64_linux:      "dc04097b830375f0545e227e9b096715987e81fb5db85f4a8413215091af3e2b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOBIN"] = bin
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}")

    man1.install Dir["doc/man/*.1"]
    doc.install Dir["doc/md/*.md"]

    bash_completion.install "misc/completion/bash/git-bug"
    zsh_completion.install "misc/completion/zsh/git-bug" => "_git-bug"
    fish_completion.install "misc/completion/fish/git-bug" => "git-bug.fish"
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}/git-bug version")
    # Version through git
    assert_match version.to_s, shell_output("git bug version")

    mkdir testpath/"git-repo" do
      system "git", "init", "--initial-branch=main"
      system "git", "config", "user.name", "homebrew"
      system "git", "config", "user.email", "a@a.com"
      system "yes 'a b http://www/www' | git bug user new"
      system "git", "bug", "bug", "new", "-t", "Issue 1", "-m", "Issue body"
      system "git", "bug", "bug", "new", "-t", "Issue 2", "-m", "Issue body"
      system "git", "bug", "bug", "new", "-t", "Issue 3", "-m", "Issue body"

      assert_match "Issue 2", shell_output("git bug bug 'Issue 2'")
    end
  end
end
