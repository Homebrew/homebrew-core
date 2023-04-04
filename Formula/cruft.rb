class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/00/1d/b9f0afed49a884f809fe0bb68bab458e999f22b3c41bbe6b64de2311f560/cruft-2.13.0.tar.gz"
  sha256 "5b2c15da088126a79fa00be9fc826dadd73498ffb351b5be8af8538e007ed7b6"
  license "MIT"
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a427f1318de63ec1dc0d81a3469cb721fb7f300db3cd667d3042c3fd525b0987"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8117d132628c206d42f06ae39be6537d46e544a90032edb2122ff272aea9c56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1a43d45c9e220c47832b770d2dc535c4668993aba96e23d85dbb781c052906d"
    sha256 cellar: :any_skip_relocation, ventura:        "caa0251ad91f1f7ccda65b4380fb3a2e252fba86722413f91286b8ab0de41023"
    sha256 cellar: :any_skip_relocation, monterey:       "e08b781d6b9de0b106ff4091798ddba127bd8ddfa8a2a5ea180b920baede3564"
    sha256 cellar: :any_skip_relocation, big_sur:        "a226139d94548f7fb2ddd567243687942b76d3b4a69dbb37932e660128134bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "729c98ce72ff783164868fec166c68601c3db383d209b62e2a81048ec5debf6b"
  end

  depends_on "cookiecutter"
  depends_on "python@3.11"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/5f/11/2b0f60686dbda49028cec8c66bd18a5e82c96d92eef4bc34961e35bb3762/GitPython-3.1.31.tar.gz"
    sha256 "8ce3bcf69adfdf7c7d503e78fd3b1c492af782d58893b650adb2ac8912ddd573"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e1/45/bcbc581f87c8d8f2a56b513eb994d07ea4546322818d95dc6a3caf2c928b/typer-0.7.0.tar.gz"
    sha256 "ff797846578a9f2a201b53442aedeb543319466870fbe1c701eab66dd7681165"
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
