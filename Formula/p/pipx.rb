class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/86/4e/2820045417d94d699c7fcfc81860c9d671aed87fe563a00d9a5f88993c2f/pipx-1.2.0.tar.gz"
  sha256 "d1908041d24d525cafebeb177efb686133d719499cb55c54f596c95add579286"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29e526e0b20bcdafff2cac87062b82ad24f86215040b8306c7544cd78b5a618c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd082b4191e48175c8526f6a66afabfd8d99441602b9d7e0e8f82680b5405ff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "085d9ab34f1e1d6f96f9107ae7d291eb6daf9653d49df79c8436bb9632441442"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab7bc10484f1acebdda35d32b0c682f25bce7b4df4e845b1df6eabeb2104aba6"
    sha256 cellar: :any_skip_relocation, ventura:        "8c9864bec0d66b2d997561332222c1a26553e37989aa151b6355ba21b63197cd"
    sha256 cellar: :any_skip_relocation, monterey:       "31949ecee9dd1fb9d965abb7993569dc5632a3f7553b73dc924f78a791c43012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3cc3ac14c32a9dfb8dc3f31934fc85eea2dc79e6d7edd16fece9b6ee4443ac5"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/4d/13/b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfc/userpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  def install
    virtualenv_install_with_resources

    register_argcomplete = Formula["python-argcomplete"].opt_bin/"register-python-argcomplete"
    generate_completions_from_executable(register_argcomplete, "pipx", shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
