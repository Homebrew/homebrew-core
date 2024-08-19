class GitFilterRepo < Formula
  include Language::Python::Shebang

  desc "Quickly rewrite git repository history"
  homepage "https://github.com/newren/git-filter-repo"
  url "https://github.com/newren/git-filter-repo/releases/download/v2.45.0/git-filter-repo-2.45.0.tar.xz"
  sha256 "430a2c4a5d6f010ebeafac6e724e3d8d44c83517f61ea2b2d0d07ed8a6fc555a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a31032bc52a3bad3c19880d00d52abc73e7215a748d64626c1d369d46334c43e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a31032bc52a3bad3c19880d00d52abc73e7215a748d64626c1d369d46334c43e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a31032bc52a3bad3c19880d00d52abc73e7215a748d64626c1d369d46334c43e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a31032bc52a3bad3c19880d00d52abc73e7215a748d64626c1d369d46334c43e"
    sha256 cellar: :any_skip_relocation, ventura:        "a31032bc52a3bad3c19880d00d52abc73e7215a748d64626c1d369d46334c43e"
    sha256 cellar: :any_skip_relocation, monterey:       "a31032bc52a3bad3c19880d00d52abc73e7215a748d64626c1d369d46334c43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdafd98c555e8c43f9baf3a871bbf45dbb5f8577149dddc02804013da76be66a"
  end

  depends_on "python@3.12"
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

    assert_predicate testpath/"bar", :exist?
  end
end
