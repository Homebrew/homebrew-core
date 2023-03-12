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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "336cdb8afe16eed64fbdcab33fe1d3adf6ea683ccd214154570ac6a03c3cec3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ff1598043d947aa679b8a87bc0125ac04d8599e4e6e389c9f0f436f6fbd0fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4f9211b8b3de7400bb86828fb9be542ddaef75666e346f2f46cc16b58416013"
    sha256 cellar: :any_skip_relocation, ventura:        "409a12592d278e000b95e1a047d69fffdc147d35ec63feb223ea65da4e2df2de"
    sha256 cellar: :any_skip_relocation, monterey:       "414563e8da0d2aa2084683eb7f303cacee4b3b1f43f72ef3992995cf4ee96a4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d92b440ed9159e4a2930348dd25d1e523dee2c8ba12f56c3499a7b6cfae51c61"
    sha256 cellar: :any_skip_relocation, catalina:       "90a008b483418a511f6ab9c84ea4d1b6ac8c6caa2be8c1a5a2e9f16d7fa0d83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d43fabbed1f3101bce7f698f5caf1cdff2e954e3531ff180b437f6a26979fbf5"
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
