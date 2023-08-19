class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/86/4e/2820045417d94d699c7fcfc81860c9d671aed87fe563a00d9a5f88993c2f/pipx-1.2.0.tar.gz"
  sha256 "d1908041d24d525cafebeb177efb686133d719499cb55c54f596c95add579286"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e823b669e5dd5da3981e8bfe6c4abe4fa057fbfb3e1ec163483f7b68ae471378"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec2551733c4e688523d14cd663c715d0c1ae2a9f8d485128e3a13297b24b5f19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f283303715f313620777476c76202e1d2eeabf27f7b22f380b85cc19ce6bf391"
    sha256 cellar: :any_skip_relocation, ventura:        "0bd1c1e927d5e1d9f0abdeaa56965eb4da147d0d312b2652aadd494d39605a40"
    sha256 cellar: :any_skip_relocation, monterey:       "9b1e6ca79064190f7e15e54aa8786c26f474f07f7aa54a320dd942fd8fbd8391"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf56d25e2017a76ec76398da864588c058ff1b20e8bc2302e6b57dedce0927ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c30124af6c8342b431b958cc4ecc8d2e8098275c72bf26784b430d71896d0d0"
  end

  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/ac/43/b4ac2e533f86b96414a471589948da660925b95b50b1296bd25cd50c0e3e/argcomplete-2.1.1.tar.gz"
    sha256 "72e08340852d32544459c0c19aad1b48aa2c3a96de8c6e5742456b4f538ca52f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/85/ee/820c8e5f0a5b4b27fdbf6f40d6c216b6919166780128b6714adf3c201644/userpath-1.8.0.tar.gz"
    sha256 "04233d2fcfe5cff911c1e4fb7189755640e1524ff87a4b82ab9d6b875fee5787"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/register-python-argcomplete"

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx", "--shell",
                                         shells: [:bash, :fish])
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
