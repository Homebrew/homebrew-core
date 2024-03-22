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
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ee561d031f2311e26f9dda25d7b501d2a74aa28a2e396bb6b1e1cb92f6c3b26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bb4b1a2d1b17da2f34711e8234a74a0eda0d021602ab64120ae2773335badd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fde1bc713b7bd48af84f1af32b2f9ee5c212ded7d9f63150372c09fe3f939e02"
    sha256 cellar: :any_skip_relocation, sonoma:         "e839fb10fae01f34c381450fe33679127b9f3cd2fd8e9bce7edc3f76233c8c52"
    sha256 cellar: :any_skip_relocation, ventura:        "bc9aa48286a9a341f32e7b23dac237f09a8af6fa846dcb3233719d54174c8cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "62893156973ec8839221f8551f650d48c9ca7cf388221a70318fd79f8148080c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa20cee1a3990138dce54505f4de4e290190504f310e93ee6c91e81fdcc73b0"
  end

  depends_on "python@3.12"

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
