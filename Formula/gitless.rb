class Gitless < Formula
  include Language::Python::Virtualenv

  desc "Simplified version control system on top of git"
  homepage "https://gitless.com/"
  url "https://files.pythonhosted.org/packages/9c/2e/457ae38c636c5947d603c84fea1cf51b7fcd0c8a5e4a9f2899b5b71534a0/gitless-0.8.8.tar.gz"
  sha256 "590d9636d2ca743fdd972d9bf1f55027c1d7bc2ab1d5e877868807c3359b78ef"
  license "MIT"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "90b335dbab730f102ec8567ff245cca7e184402743ad81ac9221a2bdc49ce7de"
    sha256 cellar: :any,                 arm64_big_sur:  "958dd8e95ee36be49ac1b54de1c84e0ce116097189270822879e9db91485715d"
    sha256 cellar: :any,                 monterey:       "ef5ffc5cc01fa659bd6ddd808d3a0baaec6f8a2085696fb5757664c32d505a97"
    sha256 cellar: :any,                 big_sur:        "e3da8cb38031f165bbc251bdb0ecc1114b8e83f4995656206e1209aade3eaa4d"
    sha256 cellar: :any,                 catalina:       "8c630077fe8e10e6c72715b470a980fe00985b6d26a7373f7b631f30fc1cce57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc4bf0c09a327c7093b0d46208686ab7c82c6aaac7b24b32e97b4730729fcc6a"
  end

  depends_on "libgit2"
  depends_on "python@3.10"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz"
    sha256 "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/e7/8a/e52a1c8b9878e9d9743089393f8289bb9c8a81eaab722df22df46a38b9e9/pygit2-1.10.0.tar.gz"
    sha256 "7c751eee88c731b922e4e487ee287e2e40906b2bd32d0bfd2105947f63e867de"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/7c/71/199d27d3e7e78bf448bcecae0105a1d5b29173ffd2bbadaa95a74c156770/sh-1.12.14.tar.gz"
    sha256 "b52bf5833ed01c7b5c5fb73a7f71b3d98d48e9b9b8764236237bdc7ecae850fc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
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
index 05f190a..5eb025f 100644
--- a/requirements.txt
+++ b/requirements.txt
@@ -1,6 +1,6 @@
 # make sure to update setup.py

-pygit2==0.28.2  # requires libgit2 0.28
+pygit2==1.9.0  # requires libgit2 1.4
 clint==0.5.1
 sh==1.12.14;sys_platform!='win32'
 pbs==0.110;sys_platform=='win32'
diff --git a/setup.py b/setup.py
index 68a3a87..d1704a8 100755
--- a/setup.py
+++ b/setup.py
@@ -68,7 +68,7 @@ setup(
     packages=['gitless', 'gitless.cli'],
     install_requires=[
       # make sure it matches requirements.txt
-      'pygit2==0.28.2', # requires libgit2 0.28
+      'pygit2==1.9.0', # requires libgit2 1.4
       'clint>=0.3.6',
       'sh>=1.11' if sys.platform != 'win32' else 'pbs>=0.11'
     ],
