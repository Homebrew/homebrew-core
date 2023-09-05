class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  revision 2
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "855b7fe3ee0ab2480aa0b8fbbe46eec0ad128abe4701353228cb4556c965f7a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11c57bb7e761922064d8a59d6f5d40f465553ba513f22ea3672f2013988f1c7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3192a196ecbe8a51b89fef44879f2eb175b1b3b5c5be266f3a01cac48e9641df"
    sha256 cellar: :any_skip_relocation, ventura:        "a5ea042b32858aed0816ae6e97698f1c189c0d59801f373465a09a09a7e6cb4a"
    sha256 cellar: :any_skip_relocation, monterey:       "b765a0d8ad4ae0bf139098c2abb68e50d097dd548387e68547d06387266c7f20"
    sha256 cellar: :any_skip_relocation, big_sur:        "72d1ddf5b9b0171878c3ce3eeaed9c07e13e0235738fd3d0abe6421373983240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c3b96e13b9d6d8374c1ad883b05173b98f26920f157755187300fad53b9a0c5"
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
    url "https://files.pythonhosted.org/packages/f6/7e/74206b2ac9f63a40cbfc7bfdf69cda4a3bde9d932129bee2352f6bdec555/GitPython-3.1.34.tar.gz"
    sha256 "85f7d365d1f6bf677ae51039c1ef67ca59091c7ebd5a3509aa399d4eda02d6dd"
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
