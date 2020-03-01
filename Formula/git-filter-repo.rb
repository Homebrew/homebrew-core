class GitFilterRepo < Formula
  desc "Quickly rewrite git repository history"
  homepage "https://github.com/newren/git-filter-repo"
  url "https://github.com/newren/git-filter-repo/releases/download/v2.25.0/git-filter-repo-2.25.0.tar.xz"
  sha256 "ea8cdb7dca68111e819d141fc4d302b811c1e5362c12de7403882ba9908be29c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c47ad881f6c545f5ef1ba71b0c847f5a3575a8ff626b76412362813c0fc503a5" => :catalina
    sha256 "336c9a9cf76ad1f46f47f74ad4015a905f8690612e2e02072db2300790e89895" => :mojave
    sha256 "336c9a9cf76ad1f46f47f74ad4015a905f8690612e2e02072db2300790e89895" => :high_sierra
  end

  # ignore git dependency audit:
  #  * Don't use git as a dependency (it's always available)
  # But we require Git 2.22.0+
  # https://github.com/Homebrew/homebrew-core/pull/46550#issuecomment-563229479
  depends_on "git"

  # Use any python3 version available
  # https://github.com/Homebrew/homebrew-core/pull/46550/files#r363751231
  if MacOS.version >= :catalina
    uses_from_macos "python3"
  else
    depends_on "python3"
  end

  def install
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
