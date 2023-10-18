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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57d13c6304821922437453f05db4e29aee883e527d51366dd09c85634548fd2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96f159fb005c4a9a62e72b680dee461062bb6018dc3ad5c77ea749361232ecfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f15fe3edb896c278026a62790fa1687259f9028dab9b635934c36035f979b1b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "070645bd00796c61515f6df8613aa898a25e9a13dd1d6b6a582295ff9599c4a6"
    sha256 cellar: :any_skip_relocation, ventura:        "f3e23fabe8fc07b74356e46eb62312662b285fb32c3851056c0be6464ed38786"
    sha256 cellar: :any_skip_relocation, monterey:       "08100556e7b53b2ad48f5f1f42faf06a72ed2ad16aaf240d5329fd610031268e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "588ed41906d89362973aeced4b9e04ec7f8b16e94eb316243b189522a2a4457a"
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
