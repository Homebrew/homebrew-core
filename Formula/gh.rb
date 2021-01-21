class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.5.0.tar.gz"
  sha256 "49c42a3b951b67e29bc66e054fedb90ac2519f7e1bfc5c367e82cb173e4bb056"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "daf4c5b566b1a1b9f00ac73aeffcc72792479da9ddebfdb3a91ce5d19fbba309" => :big_sur
    sha256 "b039ae32ed849b635eb7b3e1c7528d9934537c4dac76f170a2d195eab2148466" => :arm64_big_sur
    sha256 "70c9d617f18341ab35bebc17b1916ec79cc053dbed5782eb34656babdb6908a8" => :catalina
    sha256 "930dd87d86bcc1b6ac220cc488766df4fc00472d49221b37f51281970015cabe" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GH_VERSION"] = version.to_s
    ENV["GO_LDFLAGS"] = "-s -w"
    system "make", "bin/gh", "manpages"
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
