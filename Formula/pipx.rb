class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/cf/3c/df5a75794cfb58cc58329823d766da51decdfc76f6942bedfd7e0d06275b/pipx-1.1.0.tar.gz"
  sha256 "4d2f70daf15f121e90b7394b0730ee82fc39d7da514e50a7bbf8066be88883bb"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e140cb960d366318e2eca2afbab20cbe8bb57365090033e7e8d2678b11383890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bcb73c85da6959c7530a809a17a60d239d9764b890cd389acfeefe71462b78e"
    sha256 cellar: :any_skip_relocation, monterey:       "00b7e1ab842c1ae0ce37fffde172b127f98a52774865caedfea88f425dbf6aba"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fb22284e65575a43b3d64353398c117a5257a3931c1f281a15633defffb7e84"
    sha256 cellar: :any_skip_relocation, catalina:       "3adc526f451df55ab5aebb23e48293345fb64ebeabe5fdbe4721232e2c467620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "973586416833bf99a9cb0b386ffab057aeff7d1e1221661858c80a1b09eb2021"
  end

  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/85/ee/820c8e5f0a5b4b27fdbf6f40d6c216b6919166780128b6714adf3c201644/userpath-1.8.0.tar.gz"
    sha256 "04233d2fcfe5cff911c1e4fb7189755640e1524ff87a4b82ab9d6b875fee5787"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/register-python-argcomplete"

    # Install shell completions
    output = Utils.safe_popen_read(libexec/"bin/register-python-argcomplete", "--shell=bash", "pipx")
    (bash_completion/"pipx").write output

    output = Utils.safe_popen_read(libexec/"bin/register-python-argcomplete", "--shell=fish", "pipx")
    (fish_completion/"pipx.fish").write output
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
