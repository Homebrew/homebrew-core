class GitWhenMerged < Formula
  include Language::Python::Virtualenv

  desc "Find where a commit was merged in git"
  homepage "https://pypi.org/project/git-when-merged/"
  url "https://files.pythonhosted.org/packages/35/45/a2696a3a133838739baaa20fbb180b98c2c053970b2723b4384cbbc1f4a0/git-when-merged-1.2.1.tar.gz"
  sha256 "0b1addf54e9b5e428ab577a2ace5b7ebc167d067301f96447eccfc82bbad65fe"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cef2e377082bfa5b6457f6b6d19066fd7a74312860533b85fb62d6e16c0986b7"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "foo"
    system "git", "checkout", "-b", "bar"
    touch "bar"
    system "git", "add", "bar"
    system "git", "commit", "-m", "bar"
    system "git", "checkout", "master"
    system "git", "merge", "--no-ff", "bar"
    touch "baz"
    system "git", "add", "baz"
    system "git", "commit", "-m", "baz"
    system "#{bin}/git-when-merged", "bar"
  end
end
