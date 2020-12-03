class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.3.1.tar.gz"
  sha256 "5e5dca830aa5012fa1851513c10c0a5de4d3f38c16a172928b1d8e9dd9c75957"
  license "MIT"

  livecheck do
    url "https://github.com/cli/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b0bdc9b4bb1f5afe308c6f0d1546adb13dee05cc482d46c68f5e231adbf8a40b" => :big_sur
    sha256 "caedce8e0e37876250d45ea4c650997b7fdde7396bfce7b53c40bee830dd717f" => :catalina
    sha256 "2f5b27e8295b78cc1573926f100c9fa8d0efcc4e46dd99f358e4188763b1d727" => :mojave
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
