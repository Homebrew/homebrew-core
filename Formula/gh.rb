class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.2.0.tar.gz"
  sha256 "d2ff68475802292673b168c35f3f1443dd0068ad6f9e2ee11a260c843b548026"
  license "MIT"

  livecheck do
    url "https://github.com/cli/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6045fefd30216e3ddde0f473669334727234a0a33722ecf6ad441fd3c765c33e" => :catalina
    sha256 "fa3dc1ee4f82dc1b5b853dbc4b5a8d798c59b84d11281be6ee5a0c6851bc1d7e" => :mojave
    sha256 "9c01ec1dcf9c2b4304997ecf655c7f5aacbb30371ca33141d5359512e290c219" => :high_sierra
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
