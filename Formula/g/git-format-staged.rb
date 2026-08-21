class GitFormatStaged < Formula
  include Language::Python::Shebang

  desc "Git command to transform staged files using a formatting command"
  homepage "https://github.com/hallettj/git-format-staged"
  url "https://github.com/hallettj/git-format-staged/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "1144e9ebf9fdecb3ba4fd9520b72dafa80ede998b833ec9865547c9b1410bdf3"
  license "MIT"
  head "https://github.com/hallettj/git-format-staged.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "666a072db7821d60c7bbfa4455dcc15adf3726757e6a6f20c974ace2c99fd5d9"
  end

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "git-format-staged"
    inreplace "git-format-staged", "$VERSION", version.to_s
    bin.install "git-format-staged"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-format-staged --version")

    system "git", "init"
    # the tool needs a HEAD commit
    system "git", "commit", "--allow-empty", "--author=test <test@example.net>", "-m test"
    # the first 3 lines will be sorted, the last line stays for a clean merge
    (testpath/"test.txt").write "c\nb\na\ny\n"
    system "git", "add", "test.txt"
    # this change will be merged post-formatting
    (testpath/"test.txt").append_lines "z\n"

    system bin/"git-format-staged", "--formatter", "sort", "test.txt"
    # working directory has been formatted & merged
    assert_match "a\nb\nc\ny\nz\n", (testpath/"test.txt").read
    # staging has been formatted
    assert_match "a\nb\nc\ny\n", shell_output("git show :test.txt")
  end
end
