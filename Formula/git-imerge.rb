class GitImerge < Formula
  include Language::Python::Virtualenv

  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  url "https://files.pythonhosted.org/packages/be/f6/ea97fb920d7c3469e4817cfbf9202db98b4a4cdf71d8740e274af57d728c/git-imerge-1.2.0.tar.gz"
  sha256 "df5818f40164b916eb089a004a47e5b8febae2b4471a827e3aaa4ebec3831a3f"
  license "GPL-2.0-or-later"
  head "https://github.com/mhagger/git-imerge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18c1258aaf3bf4614044a508f4e9189ea2a4c751bafb3885f36147662010a435" => :catalina
    sha256 "5abf5b539420bb46a8ab7b10e43126b3719e2ebc6e0a37fc18434027ed816995" => :mojave
    sha256 "76aee24eeb5e7615e4cfbd7aaf3aacac8d8729dfcee79d8542a84cbd9b663459" => :high_sierra
    sha256 "76aee24eeb5e7615e4cfbd7aaf3aacac8d8729dfcee79d8542a84cbd9b663459" => :sierra
    sha256 "76aee24eeb5e7615e4cfbd7aaf3aacac8d8729dfcee79d8542a84cbd9b663459" => :el_capitan
  end

  depends_on "python@3.8"

  # remove the custom completiondir process
  patch :DATA

  def install
    virtualenv_install_with_resources

    bash_completion.install "completions/git-imerge"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"

    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    system "git checkout -b patch-1 && echo \"puts 'patch-1'\" > main.rb && git add main.rb && git commit -m \"Second commit\""
    assert_match "Already up-to-date.", shell_output("git-imerge rebase master")

    system "git checkout master && echo \"puts 'patch-3'\" > main2.rb && git add main2.rb && git commit -m \"main2.rb commit\""
    system "git", "checkout", "patch-1"

    expected =<<~EOS
      Attempting automerge of 1-1...success.
      Autofilling 1-1...success.
      Recording autofilled block MergeState('patch-1', tip1='master', tip2='patch-1', goal='rebase')[0:2,0:2].
      Merge is complete!
    EOS
    assert_equal expected, shell_output("git-imerge rebase master 2>&1")
  end
end


__END__
diff --git a/setup.py b/setup.py
index 3ee0551..268b40d 100644
--- a/setup.py
+++ b/setup.py
@@ -6,20 +6,6 @@ from setuptools import setup
 with open("README.md", "r") as fh:
     long_description = fh.read()

-data_files = []
-try:
-    completionsdir = subprocess.check_output(
-        ["pkg-config", "--variable=completionsdir", "bash-completion"]
-    )
-except OSError as e:
-    if e.errno != errno.ENOENT:
-        raise
-else:
-    completionsdir = completionsdir.strip().decode('utf-8')
-    if completionsdir:
-        data_files.append((completionsdir, ["completions/git-imerge"]))
-
-
 setup(
     name="git-imerge",
     description="Incremental merge for git",
@@ -31,7 +17,6 @@ setup(
     long_description_content_type="text/markdown",
     license="GPLv2+",
     py_modules=["gitimerge"],
-    data_files=data_files,
     entry_points={"console_scripts": ["git-imerge = gitimerge:climain"]},
     python_requires=">=2.7, !=3.0.*, !=3.1.*, !=3.2.*, !=3.3.*",
     classifiers=[
