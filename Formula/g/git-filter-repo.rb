class GitFilterRepo < Formula
  include Language::Python::Shebang

  desc "Quickly rewrite git repository history"
  homepage "https://github.com/newren/git-filter-repo"
  url "https://github.com/newren/git-filter-repo/releases/download/v2.47.0/git-filter-repo-2.47.0.tar.xz"
  sha256 "4662cbe5918196a9f1b5b3e1211a32e61cff1812419c21df4f47c5439f09e902"
  license "MIT"

  bottle do
    rebuild 2
    manifest_sha256 "8244311c9671002e0eafd2f3379595084b0b34adb0bc60b68020105c73f750a8"
    sha256 cellar: :any_skip_relocation, all: "d072b2c293b8b0aedd7d2396ffa477eee4f7b8b8f58e22efb95e5ae7ea72f59b"
  end

  uses_from_macos "git"
  uses_from_macos "python"

  # Fix crash when a git config value contains a line break, remove in next release
  patch do
    url "https://github.com/newren/git-filter-repo/commit/4697eeb37b7c3c30b0492e344f6b89f7139cef26.patch?full_index=1"
    sha256 "3e9955e75df5d5c43e4adfde9fae62c0738b3e97df980d97f2e4451094806cd2"
    type :backport
    resolves "https://github.com/newren/git-filter-repo/issues/684"
  end

  deny_network_access!

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "git-filter-repo"
    bin.install "git-filter-repo"
    man1.install "Documentation/man1/git-filter-repo.1"
  end

  test do
    system bin/"git-filter-repo", "--version"

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"
    system "git", "config", "test.multiline", "first\nsecond"

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
