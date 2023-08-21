class GitImerge < Formula
  include Language::Python::Virtualenv

  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/mhagger/git-imerge.git", branch: "master"

  stable do
    url "https://files.pythonhosted.org/packages/be/f6/ea97fb920d7c3469e4817cfbf9202db98b4a4cdf71d8740e274af57d728c/git-imerge-1.2.0.tar.gz"
    sha256 "df5818f40164b916eb089a004a47e5b8febae2b4471a827e3aaa4ebec3831a3f"

    # PR ref, https://github.com/mhagger/git-imerge/pull/176
    # remove in next release
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d92935aec65d9d6c68d6517d0974ee7da92be9b9d2deb0b7508234499860e56b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92935aec65d9d6c68d6517d0974ee7da92be9b9d2deb0b7508234499860e56b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d92935aec65d9d6c68d6517d0974ee7da92be9b9d2deb0b7508234499860e56b"
    sha256 cellar: :any_skip_relocation, ventura:        "25a0367e58ad1afa702446005dc2a80e4802c9bd300b810d43cb72f29cac4959"
    sha256 cellar: :any_skip_relocation, monterey:       "25a0367e58ad1afa702446005dc2a80e4802c9bd300b810d43cb72f29cac4959"
    sha256 cellar: :any_skip_relocation, big_sur:        "25a0367e58ad1afa702446005dc2a80e4802c9bd300b810d43cb72f29cac4959"
    sha256 cellar: :any_skip_relocation, catalina:       "25a0367e58ad1afa702446005dc2a80e4802c9bd300b810d43cb72f29cac4959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fccde85a49be5f7819e50cca5dcc2fe8b06f0b10051d5a9b5369a5ffb9ddce26"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
    bash_completion.install "completions/git-imerge"
  end

  test do
    system "git", "config", "--global", "init.defaultBranch", "master"
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"

    system "git", "checkout", "-b", "test"
    (testpath/"test").append_lines "bar"
    system "git", "commit", "-m", "Second commit", "test"
    assert_equal "Already up-to-date.", shell_output("#{bin}/git-imerge merge master").strip

    system "git", "checkout", "master"
    (testpath/"bar").write "bar"
    system "git", "add", "bar"
    system "git", "commit", "-m", "commit bar"
    system "git", "checkout", "test"

    expected_output = <<~EOS
      Attempting automerge of 1-1...success.
      Autofilling 1-1...success.
      Recording autofilled block MergeState('master', tip1='test', tip2='master', goal='merge')[0:2,0:2].
      Merge is complete!
    EOS
    assert_match expected_output, shell_output("#{bin}/git-imerge merge master 2>&1")
  end
end

__END__
$ git diff
diff --git a/setup.py b/setup.py
index 3ee0551..27a03a6 100644
--- a/setup.py
+++ b/setup.py
@@ -14,6 +14,9 @@ try:
 except OSError as e:
     if e.errno != errno.ENOENT:
         raise
+except subprocess.CalledProcessError:
+    # `bash-completion` is probably not installed. Just skip it.
+    pass
 else:
     completionsdir = completionsdir.strip().decode('utf-8')
     if completionsdir:
