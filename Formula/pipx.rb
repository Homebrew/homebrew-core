class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/40/ff/bf70ebf9f5a58a80e7099462a836ae0dd0dba2f339962a2955427a3c8f91/pipx-0.16.5.tar.gz"
  sha256 "2a12ee8911d36c0fc08ad3dba78c7d002797810e562739a34e1a2ce6acd85019"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "368679de313c91bb95ae0b618cee93b2cccf0f9f8d6a969f98165d8a7c4fa8cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "368679de313c91bb95ae0b618cee93b2cccf0f9f8d6a969f98165d8a7c4fa8cf"
    sha256 cellar: :any_skip_relocation, monterey:       "b310cf1250d3dc6b002bd4f709015105ccc593a57aee1aa2b79cb308ac6f6214"
    sha256 cellar: :any_skip_relocation, big_sur:        "b310cf1250d3dc6b002bd4f709015105ccc593a57aee1aa2b79cb308ac6f6214"
    sha256 cellar: :any_skip_relocation, catalina:       "b310cf1250d3dc6b002bd4f709015105ccc593a57aee1aa2b79cb308ac6f6214"
    sha256 cellar: :any_skip_relocation, mojave:         "b310cf1250d3dc6b002bd4f709015105ccc593a57aee1aa2b79cb308ac6f6214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "469a03613a40a9ea0d30ea0779274f7abab1270297111522bbb7cbb0b2a4c8d1"
  end

  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "distro" do
    on_linux do
      url "https://files.pythonhosted.org/packages/a5/26/256fa167fe1bf8b97130b4609464be20331af8a3af190fb636a8a7efd7a2/distro-1.6.0.tar.gz"
      sha256 "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424"
    end
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
