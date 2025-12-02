class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/git-bug/git-bug"
  url "https://github.com/git-bug/git-bug/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "1b5cafa3d9918ce18c4674c93b83359e211def83e716d5841fa93c77b457e6c2"
  license "GPL-3.0-or-later"
  head "https://github.com/git-bug/git-bug.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec89cbb8556d9825da3d5211cfd8e8091387081f365c52cf505e98f5e7ca70d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46a716e687114907ed936a8c22b5fa1ca9658eecb26a0537ec894f97ae2c4ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5744168a1453fba21ab2782333d4015f9cd9c1b9497ebc909d350af435da737c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a271df2167a6a767e15beb87eea6eed4245f09db052f3f61b1cd5136349709de"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5bb614c77aca72bf32c5d2809befa82500f59fc5b603366d261cd83ac7f5762"
    sha256 cellar: :any_skip_relocation, ventura:       "8721018faf434cc44ecad8440923d69c41886c780e8e10ac73942d8532696de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b84957c63e145ff5a12b5dac9cea8023ca7e7870f04f4ba92581a3811b11bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c614beca0af4af926599abdd8959820da8cb6621c7c4451ffaaef8cc00a9c268"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ldflags = %W[
      -s -w
      -X github.com/git-bug/git-bug/commands.GitCommit="v#{tap.user}"
      -X github.com/git-bug/git-bug/commands.GitLastTag="v#{version}"
      -X github.com/git-bug/git-bug/commands.GitExactTag="v#{version}"
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:)

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
