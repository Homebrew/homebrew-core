class Legit < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "http://www.git-legit.org/"
  url "https://github.com/kennethreitz/legit/archive/v0.2.1.tar.gz"
  sha256 "3b30e47262f3a727cc7aeb7e4842d82e9e2f9cc29145a361c097d7cc372a9a66"
  head "https://github.com/kennethreitz/legit.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c6bbed14527c371e67b24258acb60429aa0182af1369012fce3a44f472970f7" => :sierra
    sha256 "f4f9a9bf8fa183a111980dc8601b71369e586c461434a034d975fa408802a055" => :el_capitan
    sha256 "a27c8ca66c3f479f40e69a5c4fbdb32198421145ceccb0fe87d800982613f409" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/e3/95/7e5d7261feb46c0539ac5e451be340ddd64d78c5118f2d893b052c76fe8c/gitdb-0.6.4.tar.gz"
    sha256 "a3ebbc27be035a2e874ed904df516e35f4a29a778a764385de09de9e0f139658"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/cb/a0/9b063d09bbc847b98df115571041287d7e38ff1b45ed1c91534d15057cf6/GitPython-2.0.8.tar.gz"
    sha256 "7c03d1130f903aafba6ae5b89ccf8eb433a995cd3120cbb781370e53fc4eb222"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/bc/aa/b744b3761fff1b10579df996a2d2e87f124ae07b8336e37edc89cc502f86/smmap-0.9.0.tar.gz"
    sha256 "0e2b62b497bd5f0afebc002eda4d90df9d209c30ef257e8673c90a6b5c119d62"
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
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "init"
    system "git", "remote", "add", "origin", "https://github.com/git/git.git"
    system "#{bin}/legit", "sprout", "test"
    assert_match(/test/, shell_output("#{bin}/legit branches"))
  end
end
