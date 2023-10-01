class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/86/4e/2820045417d94d699c7fcfc81860c9d671aed87fe563a00d9a5f88993c2f/pipx-1.2.0.tar.gz"
  sha256 "d1908041d24d525cafebeb177efb686133d719499cb55c54f596c95add579286"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af06c34c6621ad287f4a7450c12b4567da9fc1128829763f515124cd01271803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a57e651b361d784c1ee4eddb62c5ba81b044942b602b7c7e908e3f111c1c284"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3cbcbcad6035e11cb4d191445139335f376f3ad392f65d880da49bbbe86f581"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c9d71e785cd5a0effc8c4efcfb94d33a6b31cedc19c2298b8e15dc51fc06d11"
    sha256 cellar: :any_skip_relocation, sonoma:         "db80cb8acb1acf0bcc834a7ddcb43810cffc9ff691f5a45a63cc6f1ff2b626f4"
    sha256 cellar: :any_skip_relocation, ventura:        "91e477d005dec847be8d458fb4550d750ee5c468c23a92445860992e24020231"
    sha256 cellar: :any_skip_relocation, monterey:       "41834ffcf2421615bc1a78f03997f15626f78fa000f2893458ebabe59477ab59"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea510e2636cdeb61c0e8128bc01166278db47ae6fab8d1cec05376a3bb2d7813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499bea282b4a69adbb11f61977da1429cbbe733065a48ca450f24361dfefee8b"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/ac/43/b4ac2e533f86b96414a471589948da660925b95b50b1296bd25cd50c0e3e/argcomplete-2.1.1.tar.gz"
    sha256 "72e08340852d32544459c0c19aad1b48aa2c3a96de8c6e5742456b4f538ca52f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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
