class Legit < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "https://frostming.github.io/legit/"
  url "https://files.pythonhosted.org/packages/cb/e4/8cc5904c486241bf2edc4dd84f357fa96686dc85f48eedb835af65f821bf/legit-1.2.0.post0.tar.gz"
  sha256 "949396b68029a8af405ab20c901902341ef6bd55c7fec6dab71141d63d406b11"
  license "BSD-3-Clause"
  revision 9
  head "https://github.com/frostming/legit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f434dfaecf2aafc03861a83142d4753d89d6cb54a063e160e50950b063f63a8"
  end

  depends_on "python@3.14"

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "crayons" do
    url "https://files.pythonhosted.org/packages/b8/6b/12a1dea724c82f1c19f410365d3e25356625b48e8009a7c3c9ec4c42488d/crayons-0.4.0.tar.gz"
    sha256 "bd33b7547800f2cfbd26b38431f9e64b487a7de74a947b0fafc89b45a601813f"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/e1/63/210aaa302d6a0a78daa67c5c15bbac2cad361722841278b0209b6da20855/gitpython-3.1.49.tar.gz"
    sha256 "42f9399c9eb33fc581014bedd76049dfbaf6375aa2a5754575966387280315e1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"legit", shell_parameter_format: :click)
    man1.install "extra/man/legit.1"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
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
