class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  revision 3
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db9965b04a41d22b832d7577d603addcec08020f67bd1e7d70306b08557d2b79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e56fa8b73b043e22323305817df1c7d4fcad18b985f80a8fd8e3b6eca47e1093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82331c9593ab52350c1e734ee93814679bcd892509782ccd0c60f2527979fc91"
    sha256 cellar: :any_skip_relocation, ventura:        "b1a02c457851993c9f9a44815a3ed6998f5ee75eb2238f5e34ba265c5b601898"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3e1d55220c514654bdab569c09da751e16b3acce2ffa1e9867c1f2ea4db293"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d866955076136994bbb5cb667998d34b46bd849281f2f91950f870cacd03c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8d006f394191b34543c5a1b502cabc95c08f8fe928fee5079c9615818cca436"
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
    url "https://files.pythonhosted.org/packages/95/4e/8b8aac116a00f0681117ed3c3f3fc7c93fcf85eaad53e5e6dea86f7b8d82/GitPython-3.1.35.tar.gz"
    sha256 "9cbefbd1789a5fe9bcf621bb34d3f441f3a90c8461d377f84eda73e721d9b06b"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
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
