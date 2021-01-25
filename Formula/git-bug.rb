class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/MichaelMure/git-bug"
  url "https://github.com/MichaelMure/git-bug.git",
      tag:      "0.7.1",
      revision: "2d64b85db71a17ff3277bbbf7ac9d8e81f8e416c"
  license "GPL-3.0"
  head "https://github.com/MichaelMure/git-bug.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "874a11e7af28e1d085e19803e9056287906a531f438894e853343e3d5d3d46e4" => :big_sur
    sha256 "58ea13c7cfe68fa51484a16808a7ef3506573f9f502402e1c28273bad9960035" => :arm64_big_sur
    sha256 "6b22d352d4f7ac655ab3544593cbdbcb1d1ad6e2f87dd0f7066e31a9319aa97b" => :catalina
    sha256 "c5a308416b902fbd59bd1df0bd17074f5bc9d8de594a07573b8d074889cb45fd" => :mojave
    sha256 "0617df6821ac81888aa4ba8b38102031b17fb64b6b25b20554a454e3e4a1fd60" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    man1.install Dir["doc/man/*.1"]
    doc.install Dir["doc/md/*.md"]
    bash_completion.install "misc/bash_completion/git-bug"
    zsh_completion.install "misc/zsh_completion/git-bug" => "_git-bug"
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}/git-bug --version")
    # Version through git
    assert_match version.to_s, shell_output("git bug --version")

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
