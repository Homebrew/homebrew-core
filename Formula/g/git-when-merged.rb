class GitWhenMerged < Formula
  include Language::Python::Shebang

  desc "Find where a commit was merged in git"
  homepage "https://github.com/mhagger/git-when-merged"
  url "https://github.com/mhagger/git-when-merged/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "46ba5076981862ac2ad0fa0a94b9a5401ef6b5c5b0506c6e306b76e5798e1f58"
  license "GPL-2.0-only"
  head "https://github.com/mhagger/git-when-merged.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2eaa583d95ad40ab71601ea90261449fead78a76e54c07ce44d7eff6f556e69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2eaa583d95ad40ab71601ea90261449fead78a76e54c07ce44d7eff6f556e69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2eaa583d95ad40ab71601ea90261449fead78a76e54c07ce44d7eff6f556e69"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2eaa583d95ad40ab71601ea90261449fead78a76e54c07ce44d7eff6f556e69"
    sha256 cellar: :any_skip_relocation, ventura:        "c2eaa583d95ad40ab71601ea90261449fead78a76e54c07ce44d7eff6f556e69"
    sha256 cellar: :any_skip_relocation, monterey:       "c2eaa583d95ad40ab71601ea90261449fead78a76e54c07ce44d7eff6f556e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f47d13d3c0efac1f4ab3769f7602284a92fded793d7eb547253abd4cdf0ddac4"
  end

  # TODO: Update this to whichever python has `bin/python3`.
  depends_on "python@3.12" => :test
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
