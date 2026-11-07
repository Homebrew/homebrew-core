class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/git-bug/git-bug"
  url "https://github.com/git-bug/git-bug/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "d02f75b5ca4a6ab7d8cd0bf028cee8f090ccd7f07854b5edeb4953957b75e39a"
  license "GPL-3.0-or-later"
  head "https://github.com/git-bug/git-bug.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee3013a6d25e298a74f0246b2d1d4e256f263a2565a85a4bf9754299968b151b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ecf692341b6d5713dfdc9ecaff6422cd5fa08e7b7181eeebcdbb2eabd95ec4bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c045a269cf20a3b60422fc670770703e6f30583116ef68ae19dd5b7791587234"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6efca2224e87ef7df8b0a323e47f8f8f51704e21866679b8149dce44b141a675"
    sha256 cellar: :any,                 x86_64_linux:      "21a974cab95bbd8de8a742aa952a570a2930313f58013637b81268e0df1a4b57"
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
