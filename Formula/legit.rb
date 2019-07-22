class Legit < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "https://frostming.github.io/legit/"
  url "https://files.pythonhosted.org/packages/44/72/a086485566cf7b5ff7b6858b7dc144c76323e021d88f455ceacd5a6c02fd/legit-1.0.1.tar.gz"
  sha256 "e71c2dd4139afc0e4b8c2d1b5ab1265ad930e2cc8e4d6badf92923cee4e5baff"
  revision 1
  head "https://github.com/frostming/legit.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cd13538dc7d6e78000b8924ee997ff49a64b9de1ce173249c7ea64301caeb99" => :mojave
    sha256 "9ad1bfcc74bb8a6df6ed3cc3e1f049350ef1431398623415b501df16f6449c59" => :high_sierra
    sha256 "035a8b4fc67b0f6d5cb5919f551883c51046abcd1b1f5dc7937d02f703b76709" => :sierra
  end

  depends_on "python"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "crayons" do
    url "https://files.pythonhosted.org/packages/14/fa/635fdd47686a0f29692d927333fcf39e0279fc39c81704866c97adc34053/crayons-0.1.2.tar.gz"
    sha256 "5e17691605e564d63482067eb6327d01a584bbaf870beffd4456a3391bd8809d"
  end

  resource "gitdb2" do
    url "https://files.pythonhosted.org/packages/84/11/22e68bd46fd545b17d0a0b200cf75c20e9e7b817726a69ad5f3070fd0d3c/gitdb2-2.0.3.tar.gz"
    sha256 "b60e29d4533e5e25bb50b7678bbc187c8f6bcff1344b4f293b2ba55c85795f09"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/1c/08/a2b5ba4ad43c4c33066ced2c45958593ab2554bb0d09f7ecb9bf9092e5f6/GitPython-2.1.8.tar.gz"
    sha256 "ad61bc25deadb535b047684d06f3654c001d9415e1971e51c9c20f5b510076e9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/77/32/439f47be99809c12ef2da8b60a2c47987786d2c6c9205549dd6ef95df8bd/packaging-17.1.tar.gz"
    sha256 "f019b770dd64e585a99714f1fd5e01c7a8f11b45635aa953fd41c689a657375b"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "smmap2" do
    url "https://files.pythonhosted.org/packages/48/d8/25d9b4b875ab3c2400ec7794ceda8093b51101a9d784da608bf65ab5f5f5/smmap2-2.0.3.tar.gz"
    sha256 "c7530db63f15f09f8251094b22091298e82bf6c699a6b8344aaaef3f2e1276c3"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "extra/bash-completion/legit"
    zsh_completion.install "extra/zsh-completion/_legit"
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
