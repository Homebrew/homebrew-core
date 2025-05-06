class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/git-bug/git-bug"
  url "https://github.com/git-bug/git-bug.git",
      tag:      "v0.8.1",
      revision: "96c7a111a3cb075b5ce485f709c3eb82da121a50"
  license "GPL-3.0-or-later"
  head "https://github.com/git-bug/git-bug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aace4173880bff60e66e06833fcb5acbe4e4c1d8f86051ff89fb9566cb6b4a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33fe5500a265b98d4af1445c3e428c15b7a61a206d707a109a3610b3e169a850"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a15b100034db1c38161c6b02a7cfc3fc38b6f680ef4aacd1468031bc28c286d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "444acfa855ed5379698bfeb4b99075b564b173ec5f1bc3fa141abe0a144858a6"
    sha256 cellar: :any_skip_relocation, ventura:       "ab1f4c9cd703a55094d10b36c038f95c289de4c30ffb66fb5a18ddb18f2bd04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "636b5364c54e97dec3062870c780f54b2ffed5a4dc9c3e9c880e98191de502d7"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

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
