class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/28/ea/0e826dc4cf82ed929a3bdcd4e0d2918ee53af6b8c6b0cbc5809630526b36/pipx-1.0.0.tar.gz"
  sha256 "91e2bca934a5e82785d7b4ae44b95553611311691bd87da31915d08a0ad2df1c"
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
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/60/2c/0620bacd069a14a601b0a5ba4578b223fa6ae34b9dd97e5508798b7f3dee/userpath-1.7.0.tar.gz"
    sha256 "dcd66c5fa9b1a3c12362f309bbb5bc7992bac8af86d17b4e6b1a4b166a11c43f"
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
