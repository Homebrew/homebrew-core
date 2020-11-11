class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.2.1.tar.gz"
  sha256 "ae7f03426b9d9ebf40be3cdbd4ce8cec7aeeda8e51acd34d8d0aaf0b3c4ea550"
  license "MIT"

  livecheck do
    url "https://github.com/cli/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2cf5e27ef30b950e0161fa3e73d773c8aeb5a8d0e6b05932aab088e58c0eb0bb" => :catalina
    sha256 "0e3c59f16c70913845620111ddea0af3038daed72919f1367932c03b37aabd75" => :mojave
    sha256 "5686cd9ea59109312c3cefbab7bd40eff279e277a755a87bb77e9972864fc5bc" => :high_sierra
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
