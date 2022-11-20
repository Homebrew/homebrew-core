class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/MichaelMure/git-bug"
  url "https://github.com/MichaelMure/git-bug.git",
      tag:      "v0.8.0",
      revision: "a3fa445a9c76631c4cd16f93e1c1c68a954adef7"
  license "GPL-3.0-or-later"
  head "https://github.com/MichaelMure/git-bug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9955d843ba0fb77f1b9005d5a4bc6f3ab41bb29686e5705d7e04c73eb8be726c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beeb321dc338263445c5a092cee6d627679ef38f65ef449cbcbf1d3dee53983b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7477b094e81aa878baf489654c8b131c6d8ebd40222b41769481e298089ba019"
    sha256 cellar: :any_skip_relocation, monterey:       "cc519ce7c73d26de779c4eb14118e0dc01c160d463e42b54c380e629f5e9cd5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "26ead98df2569b14356aac45755b68397dceca6a0dc2cdb6ec00f1a4926fc669"
    sha256 cellar: :any_skip_relocation, catalina:       "60c08117214d4d8657e67f182d1380b291882944d69c54c9adaa0f8140e28993"
    sha256 cellar: :any_skip_relocation, mojave:         "6184e21ba0f2c4c28722dd7276004f2f430e02e4f2cf56462b4914d08df6f2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "234a0d2749668c523e59bf359cdb0484d984fc4230cbe72c64c0ff585eaef6cc"
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
      system "git", "init"
      system "git", "config", "user.name", "homebrew"
      system "git", "config", "user.email", "a@a.com"
      system "yes 'a b http://www/www' | git bug user create"
      system "git", "bug", "add", "-t", "Issue 1", "-m", "Issue body"
      system "git", "bug", "add", "-t", "Issue 2", "-m", "Issue body"
      system "git", "bug", "add", "-t", "Issue 3", "-m", "Issue body"

      assert_match "Issue 2", shell_output("git bug ls")
    end
  end
end
