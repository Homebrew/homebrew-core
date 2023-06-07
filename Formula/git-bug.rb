class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/MichaelMure/git-bug"
  url "https://github.com/MichaelMure/git-bug.git",
      tag:      "v0.8.0",
      revision: "a3fa445a9c76631c4cd16f93e1c1c68a954adef7"
  license "GPL-3.0-or-later"
  head "https://github.com/MichaelMure/git-bug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be920be6f96dbd7da1c1054238ce09eca5b50c3402f8eedb7a603869ea00e6f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1240cbfd96aefb7b6db471836b3cd67a622ad265bab6482c6998243177326cca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe0a8f7fae9cf1519ae096f7a65e1752ec80dcb72f371673766fc31229d1aacb"
    sha256 cellar: :any_skip_relocation, ventura:        "cf66ca73898446e52c7231dbc4dba8f1d765a456c3ef8214b9ed167dea26db4f"
    sha256 cellar: :any_skip_relocation, monterey:       "c1c29f2a9a1ff994644ab1bb42778c6ec8d7bae2589689ee7efbf5200c626c76"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a76c51936c483ccfdeead7e119751fc70989f3387e0bc5e93d8252005a2183e"
    sha256 cellar: :any_skip_relocation, catalina:       "553181a157cfed0dc321bc90dd789256177ca86df0d4aef8a75c787642d4434a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc86c9ec48daf126f20298325c4d9b2d269025d6d0612eab3d4831a1402abfe7"
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
