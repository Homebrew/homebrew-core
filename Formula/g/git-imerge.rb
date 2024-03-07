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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2553c9a8ab46a5e1a8eba30fae465f3f18904a805d18b4dabead2a2834f7ffe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be9be74bcab3fe1e9647f15d73679116fb603a2099e3ba9c14f3fe68c5b5d41c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31be9d067a48d1eedcfeb0d937d4ea50f06fb7f9e4abb3fce89eef8e4016f6a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "896e8ca74494b063750de2bca61fce0ac58b46d64befb9e2e8fe2097010f4262"
    sha256 cellar: :any_skip_relocation, ventura:        "a58c276c1b031d5a13f03218fa2091de8a544d48e1c015b548338cd4ec2528d4"
    sha256 cellar: :any_skip_relocation, monterey:       "8911acc2155e1f094a6b90080d2161d82139a01ae27d823efbf02ba25ab6d5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f10ccf33457be8b0e265a79b4f270c9c6c8aa5c2ea51423e2b8f39d4a73847"
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
