class Gitless < Formula
  include Language::Python::Virtualenv

  desc "Simplified version control system on top of git"
  homepage "https://gitless.com/"
  url "https://files.pythonhosted.org/packages/9c/2e/457ae38c636c5947d603c84fea1cf51b7fcd0c8a5e4a9f2899b5b71534a0/gitless-0.8.8.tar.gz"
  sha256 "590d9636d2ca743fdd972d9bf1f55027c1d7bc2ab1d5e877868807c3359b78ef"
  license "MIT"
  revision 14

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "4a30fe35870b73f4ec03bd44b9cdbf6fa506dac3db42f24f7bd7439908497d9e"
    sha256 cellar: :any,                 arm64_monterey: "a3f1918e39769fcce53f50040e4851bf5f35c41116be0e95a1e839ac148e5e83"
    sha256 cellar: :any,                 arm64_big_sur:  "c342de7c562ed800ca14b8513148d39733412aa0104c4f7880c8fae78a977805"
    sha256 cellar: :any,                 monterey:       "3fa453c349e21b79ae4c05963dd2b80637522bf2d224cb6b0cdf106a204c7094"
    sha256 cellar: :any,                 big_sur:        "ce0ff616b802bb44a3a79e1384f79ad6d4d0ff25921d3376532243ab7919f802"
    sha256 cellar: :any,                 catalina:       "75b8a2cc4ae6b0bd217d0ea0b0b61284b92d18d02ace259892938ff530f1ee7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb78a00ec8a6623db1302544d51a6d98d718d0946c45640e20be35f243966d67"
  end

  depends_on "libgit2"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/e7/8a/e52a1c8b9878e9d9743089393f8289bb9c8a81eaab722df22df46a38b9e9/pygit2-1.10.0.tar.gz"
    sha256 "7c751eee88c731b922e4e487ee287e2e40906b2bd32d0bfd2105947f63e867de"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/7c/71/199d27d3e7e78bf448bcecae0105a1d5b29173ffd2bbadaa95a74c156770/sh-1.12.14.tar.gz"
    sha256 "b52bf5833ed01c7b5c5fb73a7f71b3d98d48e9b9b8764236237bdc7ecae850fc"
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
