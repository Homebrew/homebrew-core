class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0551ec5eb8070036ce70f5502369e60e619cb8d3f9188dae0d61e4ee1b301e45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "255c27f38029d06f40356438207ef1220793d0f820b51c3ad2eb807bb47b5ba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e87b5aaa7ed138f24970beb4711cea3836110aeac57eb9a7e63246851d50a042"
    sha256 cellar: :any_skip_relocation, ventura:        "38a8d0650c6275eccaeb759dcd39e5a662e0cedccbfba44f7cf3d66f37423632"
    sha256 cellar: :any_skip_relocation, monterey:       "220db383245d56d214ad916644e5ebe14a36993f8713dcfb1fb9d84588a58d83"
    sha256 cellar: :any_skip_relocation, big_sur:        "497f61d41fa8e5f7f9df3deb6000c012ed48cab943bf1d7679cda5843d253794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1a3add76476d49152e65169acb29c907dc60b6e029ed54e113709d99bfb2f09"
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
    url "https://files.pythonhosted.org/packages/5f/11/2b0f60686dbda49028cec8c66bd18a5e82c96d92eef4bc34961e35bb3762/GitPython-3.1.31.tar.gz"
    sha256 "8ce3bcf69adfdf7c7d503e78fd3b1c492af782d58893b650adb2ac8912ddd573"
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
