class GitWhenMerged < Formula
  include Language::Python::Shebang

  desc "Find where a commit was merged in git"
  homepage "https://github.com/mhagger/git-when-merged"
  url "https://github.com/mhagger/git-when-merged/archive/v1.2.1.tar.gz"
  sha256 "46ba5076981862ac2ad0fa0a94b9a5401ef6b5c5b0506c6e306b76e5798e1f58"
  license "GPL-2.0-only"
  head "https://github.com/mhagger/git-when-merged.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "351c05a7dfe0568ffde09a4633ab23d253ab10e0c3e0b2421e3f9b4740bae4b7"
  end

  # TODO: Update this to whichever python has `bin/python3`.
  depends_on "python@3.10" => :test
  uses_from_macos "python"

  def install
    bin.install "src/git_when_merged.py" => "git-when-merged"

    if !OS.mac? || MacOS.version >= :catalina
      rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"git-when-merged"
    end
  end

  test do
    system "git", "config", "--global", "init.defaultBranch", "master"
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
    system bin/"git-when-merged", "bar"

    # Test with both Homebrew Python3 and system Python3 to validate our shebang.
    which_all("python3").each do |python|
      system python, bin/"git-when-merged", "bar"
    end
  end
end
