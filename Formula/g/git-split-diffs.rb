class GitSplitDiffs < Formula
  desc "Syntax highlighted side-by-side diffs in your terminal"
  homepage "https://github.com/banga/git-split-diffs"
  url "https://registry.npmjs.org/git-split-diffs/-/git-split-diffs-2.1.0.tgz"
  sha256 "4d49a8d4fd4e674ecd639cd9057cd3e04a503af5322b61c62b82a8221fc60729"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de5be1a8af6bf08498fa775a74b84b0fa6a43f1b0a948b41aac34eb84df5971e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de5be1a8af6bf08498fa775a74b84b0fa6a43f1b0a948b41aac34eb84df5971e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de5be1a8af6bf08498fa775a74b84b0fa6a43f1b0a948b41aac34eb84df5971e"
    sha256 cellar: :any_skip_relocation, sonoma:         "de5be1a8af6bf08498fa775a74b84b0fa6a43f1b0a948b41aac34eb84df5971e"
    sha256 cellar: :any_skip_relocation, ventura:        "de5be1a8af6bf08498fa775a74b84b0fa6a43f1b0a948b41aac34eb84df5971e"
    sha256 cellar: :any_skip_relocation, monterey:       "de5be1a8af6bf08498fa775a74b84b0fa6a43f1b0a948b41aac34eb84df5971e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e479320545a1b6326b0a5d99b932bc9c56909616c6fc950ef98f327b50712301"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "commit", "-m", "Second commit"

    system "git", "config", "--global", "core.pager", "git-split-diffs --color | less -RFX"

    assert_match "bar", shell_output("git diff HEAD^1...HEAD")
  end
end
