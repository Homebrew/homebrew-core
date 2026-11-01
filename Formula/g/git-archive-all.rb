class GitArchiveAll < Formula
  include Language::Python::Shebang

  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/refs/tags/1.24.0.tar.gz"
  sha256 "d7eb0c7ef3e908b6e666f0b8c9e583e4ea866dffb87a4590d4b8ff0fd136fb6f"
  license "MIT"
  head "https://github.com/Kentzo/git-archive-all.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce36b7566f6ac6ca8c4b175dfd97a2c205d61cb4920f53177f16139c9286d189"
  end

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "git_archive_all.py"

    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "#{testpath.realpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive").chomp
  end
end
