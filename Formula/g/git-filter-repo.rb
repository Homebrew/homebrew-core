class GitFilterRepo < Formula
  include Language::Python::Shebang

  desc "Quickly rewrite git repository history"
  homepage "https://github.com/newren/git-filter-repo"
  url "https://github.com/newren/git-filter-repo/releases/download/v2.38.0/git-filter-repo-2.38.0.tar.xz"
  sha256 "db954f4cae9e47c6be3bd3161bc80540d44f5379cb9cf9df498f4e019f0a41a9"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "bd20e32d8074540db1ffa2f77ab7581328c96adab2aa21848c4e330c1bf918fe"
  end

  depends_on "python@3.12"
  uses_from_macos "git", since: :catalina # git 2.22.0+ is required

  def install
    rewrite_shebang detected_python_shebang, "git-filter-repo"
    bin.install "git-filter-repo"
    man1.install "Documentation/man1/git-filter-repo.1"
  end

  test do
    system "#{bin}/git-filter-repo", "--version"

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"

    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "foo"
    # Use --force to accept non-fresh clone run:
    # Aborting: Refusing to overwrite repo history since this does not look like a fresh clone.
    # (expected freshly packed repo)
    system "#{bin}/git-filter-repo", "--path-rename=foo:bar", "--force"

    assert_predicate testpath/"bar", :exist?
  end
end
