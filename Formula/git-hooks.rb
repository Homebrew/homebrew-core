class GitHooks < Formula
  desc "Manage project, user, and global Git hooks"
  homepage "https://github.com/icefox/git-hooks"
  url "https://github.com/icefox/git-hooks/archive/1.00.0.tar.gz"
  sha256 "8197ca1de975ff1f795a2b9cfcac1a6f7ee24276750c757eecf3bcb49b74808e"
  head "https://github.com/icefox/git-hooks.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d33514436cb623e468314418876fe1e7bb8c31ee64fdcd3c9a297f26a7e7ae42" => :catalina
    sha256 "a66bf94650a35829721b07c4f6a497154c9e667917ea8c28418b870c0de15697" => :mojave
    sha256 "710495206af282348fa5e311f825bdbbcb7a891345ff467468908e16b3dbc090" => :high_sierra
    sha256 "aaceeb7b390f71c45e3c1db15c23ab664a06bfc34de1c629a2b2f5b29e1bdec2" => :sierra
    sha256 "bdfffb820e5a7574169b91113ed59c578ebe88bcea8c890166a33fb9af17c0ce" => :el_capitan
    sha256 "d4c5fba7f1b80e8e68762356a2f64ac216bf4e9f3151cf2f236c92a9524b97ed" => :yosemite
    sha256 "ace6acaff04ef09795d26e6034bf411a89c9f348287dd95f756c82068cea123d" => :mavericks
  end

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
