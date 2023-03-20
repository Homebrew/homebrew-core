class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/1d/a2/e3bfcc5780b9e3cde61940155cd31a4dd9a7432851561239475ada60eaef/cruft-2.12.0.tar.gz"
  sha256 "57455d33a60684c945d501dcea2b1c57dc0fb200a0090f07c83da1603382cbb1"
  license "MIT"
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d845e740b9f1d25ee43e108e904d2a5651e6b43bc6e36296286d2966d3aa721b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b26a63b8acfcb7c3a701abc9fb3ccc46f3c718129c28d2e8694c98658f6e8d4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddc567dba14c79e3325932590963a7676696f842c0013e52581966d170e0caf3"
    sha256 cellar: :any_skip_relocation, ventura:        "cd1f537e849a19f24386742dd40e6c5e61293f3564a67b066b2815406d989eb6"
    sha256 cellar: :any_skip_relocation, monterey:       "86cb8f565f2f0c98d2a9e9a438eea5ee5f17e0c4429d077bc916beaaffa55b00"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0610f2abf51203ed9d8d32a3cfcf34032e7c6cd238007d1f89503656bc48f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "871be0e45ae6a9309adc7d388eddda17b65f358eff9748b9806a2bd9ea142eb4"
  end

  depends_on "cookiecutter"
  depends_on "python@3.11"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
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
