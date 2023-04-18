class Legit < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "https://frostming.github.io/legit/"
  url "https://files.pythonhosted.org/packages/cb/e4/8cc5904c486241bf2edc4dd84f357fa96686dc85f48eedb835af65f821bf/legit-1.2.0.post0.tar.gz"
  sha256 "949396b68029a8af405ab20c901902341ef6bd55c7fec6dab71141d63d406b11"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/frostming/legit.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c5c0cfe02e4bfbfbf317b6497d053383c890108681e509ffe860e309ec3c4dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e05fd8a51bf20e69fa663faaf63eb849fc571d1ebb60d9c12cf682649866b91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aff01568c3bd19aeea61c6178489d89398c2a45b4f7848ce4e12c9172e418119"
    sha256 cellar: :any_skip_relocation, ventura:        "50a9343aaca8abf4e65797d41cd3694649ebb420aa82e4d338f70eb3386502ee"
    sha256 cellar: :any_skip_relocation, monterey:       "bb96cbb5c46cdb0cf70f284deb561914ef6df5cf58bc994ea552b83d45b6d25d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac152c3c80f71a7603033ed36e9c13a84f877fd174bcb6d773d2607fb016d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df26fa697c854d6c210f06241ec9739bf40d8e69c3ab53d72f2fb7de1ea75e5b"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
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
