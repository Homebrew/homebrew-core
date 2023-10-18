class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  revision 5
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "557c20920b34919b1acc303a550f67e5197111a54920a93d7cec1820112a4abc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d4f24153c2245770c2650cf3674c834c305ad38e0dac66bd8b767e2b9bfe8fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b85f1f4fab09015ae89cb63c79a65f24f1b2cc8c77baedf07b0b906e6cc9be5"
    sha256 cellar: :any_skip_relocation, sonoma:         "47f16d1c7709a921bda8542fb82217b06503646d8a38445e6cd6e48c4ef00525"
    sha256 cellar: :any_skip_relocation, ventura:        "339d30c7a708535daa26d0681ac9e4b5a7b84c495e9fc488233d5dc391a2d59c"
    sha256 cellar: :any_skip_relocation, monterey:       "42089654b741fcef152cc2c37ccd5eb686453a4398231dcf49d49e50d7e93405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08eae5f76ee5b4ae0061b567851dced87a28fdd4926ac1e7139f7e66aca617b"
  end

  depends_on "cookiecutter"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
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

  def python3
    which("python3.12")
  end

  def install
    virtualenv_install_with_resources

    # we depend on cookiecutter, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages(python3)
    cookiecutter = Formula["cookiecutter"].opt_libexec
    (libexec/site_packages/"homebrew-cookiecutter.pth").write cookiecutter/site_packages
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end
