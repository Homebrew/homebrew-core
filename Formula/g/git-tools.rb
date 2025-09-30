class GitTools < Formula
  include Language::Python::Shebang

  desc "Assorted git-related scripts and tools"
  homepage "https://github.com/MestreLion/git-tools"
  url "https://github.com/MestreLion/git-tools/archive/refs/tags/v2025.08.tar.gz"
  sha256 "65eb05f2959861d16e60d132b2175169e6e1aec840ab6e4bae556c6d08a199a7"
  license "GPL-3.0-or-later"
  head "https://github.com/MestreLion/git-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba1a42e203720e6a74dcdfefb2653be957015fbd115415686b119975f111bdb6"
  end

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "git-restore-mtime"
    bin.install buildpath.glob("git-*")
    man1.install buildpath.glob("man1/*.1")
  end

  test do
    assert_equal "git-restore-mtime version #{version}", shell_output("#{bin}/git-restore-mtime --version").chomp
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "foo"
    touch "foo"
    output = shell_output("#{bin}/git-restore-mtime . 2>&1")
    assert_match "1 files to be processed in work dir", output
    assert_match "1 files updated", output
    system "git", "checkout", "-b", "testrename"
    assert_match "testrename -> test", shell_output("#{bin}/git-branches-rename -n -v testrename test")
    touch "aaa"
    assert_equal ".", shell_output("#{bin}/git-find-uncommitted-repos -u .").chomp
    assert_match "Cloning into 'test'...", shell_output(
      "FILTER_BRANCH_SQUELCH_WARNING=1 #{bin}/git-clone-subset . test foo 2>&1",
    )
  end
end
