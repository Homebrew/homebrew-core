class Legit < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "https://www.git-legit.org/"
  url "https://files.pythonhosted.org/packages/01/92/d7f9a6ccba82e996eb2cb23f33ebb0adf1ca1692b098f338cc0014f18a3b/legit-0.4.1.tar.gz"
  sha256 "642377c8a6577841d6218d52ce4f2487ea9e0495397a794ae6073d8695dbf833"
  head "https://github.com/kennethreitz/legit.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c6bbed14527c371e67b24258acb60429aa0182af1369012fce3a44f472970f7" => :sierra
    sha256 "f4f9a9bf8fa183a111980dc8601b71369e586c461434a034d975fa408802a055" => :el_capitan
    sha256 "a27c8ca66c3f479f40e69a5c4fbdb32198421145ceccb0fe87d800982613f409" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/bd/66/0a7f48a0f3fb1d3a4072bceb5bbd78b1a6de4d801fb7135578e7c7b1f563/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "gitdb2" do
    url "https://files.pythonhosted.org/packages/5c/bb/ab74c6914e3b570ab2e960fda17a01aec93474426eecd3b34751ba1c3b38/gitdb2-2.0.0.tar.gz"
    sha256 "b9f3209b401b8b4da5f94966c9c17650e66b7474ee5cd2dde5d983d1fba3ab66"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/21/13/8d0981cee1c5b9dd7fa9f836ed7c304891686f300572c03a49e52c07c04c/GitPython-2.1.1.tar.gz"
    sha256 "e96f8e953cf9fee0a7599fc587667591328760b6341a0081ef311a942fc96204"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "smmap2" do
    url "https://files.pythonhosted.org/packages/83/ce/e5b3aee7ca420b0ab24d4fcc2aa577f7aa6ea7e9306fafceabee3e8e4703/smmap2-2.0.1.tar.gz"
    sha256 "5c9fd3ac4a30b85d041a8bd3779e16aa704a161991e74b9a46692bc368e68752"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "extra/bash-completion/legit"
    zsh_completion.install "extra/zsh-completion/_legit"
    man1.install "extra/man/legit.1"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    (testpath/"foo").write("woof")
    system "git", "add", "foo"
    system "git", "commit", "-m", "init"
    system "git", "remote", "add", "origin", "https://github.com/git/git.git"
    system "git", "branch", "test"
    inreplace "foo", "woof", "meow"
    assert_match "test", shell_output("#{bin}/legit branches")
    output = shell_output("#{bin}/legit switch test")
    assert_equal "Switched to branch 'test'", output.strip.lines.last
    assert_equal "woof", (testpath/"foo").read
    system "git", "stash", "pop"
    assert_equal "meow", (testpath/"foo").read
  end
end
