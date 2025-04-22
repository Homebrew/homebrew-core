class GitFilterRepo < Formula
  include Language::Python::Shebang

  desc "Quickly rewrite git repository history"
  homepage "https://github.com/newren/git-filter-repo"
  url "https://github.com/newren/git-filter-repo/releases/download/v2.47.0/git-filter-repo-2.47.0.tar.xz"
  sha256 "4662cbe5918196a9f1b5b3e1211a32e61cff1812419c21df4f47c5439f09e902"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "719c848f3c0611b909c5d2c3a603bbe5b29e8cbee1aacf7f31e92e4618b4aff0"
  end

  depends_on "python@3.13"
  uses_from_macos "git", since: :catalina # git 2.22.0+ is required

  def install
    rewrite_shebang detected_python_shebang, "git-filter-repo"
    bin.install "git-filter-repo"
    man1.install "Documentation/man1/git-filter-repo.1"
  end

  test do
    system bin/"git-filter-repo", "--version"

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"

    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "foo"
    # Use --force to accept non-fresh clone run:
    # Aborting: Refusing to overwrite repo history since this does not look like a fresh clone.
    # (expected freshly packed repo)
    system bin/"git-filter-repo", "--path-rename=foo:bar", "--force"

    assert_path_exists testpath/"bar"
  end
end
