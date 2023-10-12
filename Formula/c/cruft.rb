class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  revision 4
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ccbe5cd5c7a2dd59b0e19d2a68a64f20ff7891ffe6d25e2183f2c43f1d81726"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "231f6dffa97a5bd168c79e94210baf31f2e7fc4f8c1dee0198beadfd6d9c58ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "712ebb93a0ae59e0db2728e901aad5cec1c336c099c90aa28212b407841134f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "580de0fe4c9166e80265a7eb7e4028bb6d3b4690e70413191f3be801215b39d7"
    sha256 cellar: :any_skip_relocation, ventura:        "28f6a10838be10edc01e71b1e5cc0b16d508518874e7d81ae073b19b60667109"
    sha256 cellar: :any_skip_relocation, monterey:       "1b400634a2b61d422b155b251165d5bd03b64b01940f2d4f5ac9c05274b7a0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "922750d6270bedad41f54b63e965e3692490a4ed751b806326c2414b90a02869"
  end

  depends_on "cookiecutter"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c6/33/5e633d3a8b3dbec3696415960ed30f6718ed04ef423ce0fbc6512a92fa9a/GitPython-3.1.37.tar.gz"
    sha256 "f9b9ddc0761c125d5780eab2d64be4873fc6817c2899cbcb34b02344bdc7bc54"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5b/49/39f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9/typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
  end

  def install
    virtualenv_install_with_resources

    # we depend on cookiecutter, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    cookiecutter = Formula["cookiecutter"].opt_libexec
    (libexec/site_packages/"homebrew-cookiecutter.pth").write cookiecutter/site_packages
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end
