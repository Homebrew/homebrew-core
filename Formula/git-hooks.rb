class GitHooks < Formula
  desc "Manage project, user, and global Git hooks"
  homepage "https://github.com/icefox/git-hooks"
  url "https://github.com/icefox/git-hooks/archive/1.00.0.tar.gz"
  sha256 "8197ca1de975ff1f795a2b9cfcac1a6f7ee24276750c757eecf3bcb49b74808e"
  head "https://github.com/icefox/git-hooks.git"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "d33514436cb623e468314418876fe1e7bb8c31ee64fdcd3c9a297f26a7e7ae42"
    sha256 cellar: :any_skip_relocation, mojave:      "a66bf94650a35829721b07c4f6a497154c9e667917ea8c28418b870c0de15697"
    sha256 cellar: :any_skip_relocation, high_sierra: "710495206af282348fa5e311f825bdbbcb7a891345ff467468908e16b3dbc090"
    sha256 cellar: :any_skip_relocation, sierra:      "aaceeb7b390f71c45e3c1db15c23ab664a06bfc34de1c629a2b2f5b29e1bdec2"
    sha256 cellar: :any_skip_relocation, el_capitan:  "bdfffb820e5a7574169b91113ed59c578ebe88bcea8c890166a33fb9af17c0ce"
    sha256 cellar: :any_skip_relocation, yosemite:    "d4c5fba7f1b80e8e68762356a2f64ac216bf4e9f3151cf2f236c92a9524b97ed"
  end

  # The icefox/git-hooks repository has been deleted and it doesn't appear to
  # have moved to an alternative location. There is a rewrite in Go by a
  # different author which someone may want to work into a new formula as a
  # replacement: https://github.com/git-hooks/git-hooks
  deprecate! date: "2020-06-25", because: :repo_removed

  conflicts_with "git-hooks-go", because: "both install `git-hooks` binaries"

  def install
    bin.install "git-hooks"
    (etc/"git-hooks").install "contrib"
  end

  test do
    system "git", "init"
    output = shell_output("git hooks").strip
    assert_match "Listing User, Project, and Global hooks", output
  end
end
