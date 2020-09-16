class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.0.0.tar.gz"
  sha256 "e3d1c341829f5b885dce9aa2bf4bc84db48072752250f6fdb2d62903caf07cfb"
  license "MIT"

  livecheck do
    url "https://github.com/cli/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "51b23104f2778db7ce43b104f38bfc8ada18f9b00550ee47db022375f54e61ed" => :catalina
    sha256 "9471ab6a21f5eb5423a0469fe90281550dd216e6cd502aff0e4ff3f88f886a7d" => :mojave
    sha256 "8123d6f50e6b5f22b3e800aeff08a52e2a4295cd3921c9a3293508287d141ba9" => :high_sierra
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
