class Gitless < Formula
  include Language::Python::Virtualenv

  desc "Simplified version control system on top of git"
  homepage "https://gitless.com/"
  url "https://files.pythonhosted.org/packages/9c/2e/457ae38c636c5947d603c84fea1cf51b7fcd0c8a5e4a9f2899b5b71534a0/gitless-0.8.8.tar.gz"
  sha256 "590d9636d2ca743fdd972d9bf1f55027c1d7bc2ab1d5e877868807c3359b78ef"
  license "MIT"
  revision 16

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "1c40014729e41a0a003e1ee46e5bb19a36f009c711b62ce4fb2e231f8734115a"
    sha256 cellar: :any,                 arm64_sonoma:  "386dd69aab3a33cea5cd627b012a470fda787e36e874d0a9906fb5aee4bc3cc0"
    sha256 cellar: :any,                 arm64_ventura: "e8fbf4d8f756335b3561196b5719f8423976b856eccd9947e9516dd0aaa242f6"
    sha256 cellar: :any,                 sonoma:        "4ec5cff232a3f893b45b29764e50c274ef294acae3ae67e39a8794f3a1f87e1e"
    sha256 cellar: :any,                 ventura:       "42dbacc0c5716aaf7a7670bbbb3aaf56b1dfd35322e79ebe354da998f70d663f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c12fac140e28d8dde8bd59cca0f7c6297e229e5c4a4b31bdde816ec53e0411f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "622c76bbb49845b2917a374693a0f6d0043fdb6f2d83b29e8a79bd2678ab90b5"
  end

  # https://github.com/gitless-vcs/gitless/issues/248
  deprecate! date: "2024-07-17", because: :unmaintained
  disable! date: "2025-07-17", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "libgit2@1.7"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/f0/5e/6e05213a9163bad15489beda5f958500881d45889b0df01d7b8964f031bf/pygit2-1.14.1.tar.gz"
    sha256 "ec5958571b82a6351785ca645e5394c31ae45eec5384b2fa9c4e05dde3597ad6"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/7c/71/199d27d3e7e78bf448bcecae0105a1d5b29173ffd2bbadaa95a74c156770/sh-1.12.14.tar.gz"
    sha256 "b52bf5833ed01c7b5c5fb73a7f71b3d98d48e9b9b8764236237bdc7ecae850fc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  # Allow to be dependent on pygit2 1.9.0
  # Remove for next version
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "config", "--global", "user.email", '"test@example.com"'
    system "git", "config", "--global", "user.name", '"Test"'
    system bin/"gl", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"gl", "track", "haunted", "house"
    system bin/"gl", "commit", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("git ls-files").strip
  end
end

__END__
diff --git a/requirements.txt b/requirements.txt
index 05f190a..6777cce 100644
--- a/requirements.txt
+++ b/requirements.txt
@@ -1,6 +1,6 @@
 # make sure to update setup.py

-pygit2==0.28.2  # requires libgit2 0.28
+pygit2==1.10.0  # requires libgit2 0.28
 clint==0.5.1
 sh==1.12.14;sys_platform!='win32'
 pbs==0.110;sys_platform=='win32'
diff --git a/setup.py b/setup.py
index 68a3a87..388ca66 100755
--- a/setup.py
+++ b/setup.py
@@ -68,7 +68,7 @@ setup(
     packages=['gitless', 'gitless.cli'],
     install_requires=[
       # make sure it matches requirements.txt
-      'pygit2==0.28.2', # requires libgit2 0.28
+      'pygit2==1.10.0', # requires libgit2 0.28
       'clint>=0.3.6',
       'sh>=1.11' if sys.platform != 'win32' else 'pbs>=0.11'
     ],
