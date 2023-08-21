class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/01/a5/28d2889629370d5d2bfeb621e8e34f21c3f7c399bb9d8e9c9b8be757ed9f/git-cola-4.3.1.tar.gz"
  sha256 "8e10084330ccd7de6ccabf4ad305608e2aa8efb68c78e851e445f09fdcb8c4ea"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a775d2b5ce13b5d901dc5147ec7cc6d835eac0143d75b1a8d29ee5f10f04a4a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df1b1fe0ab85366b1c5fb3c1bda4d49306e5d6c822501b3341e6ba2c2be4e848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dcb2709ee929d23b3119bbad85b438debc2a865c3712f00b695033daee5bf67"
    sha256 cellar: :any_skip_relocation, ventura:        "a43c4d8449f2916133a8e8411b894e5ef661d39ec9635a9de4b98a9770b7c43f"
    sha256 cellar: :any_skip_relocation, monterey:       "1b4acb1cab319bde7e3ce251a23be21366876a37ab3ad68680dfcde5e6b35471"
    sha256 cellar: :any_skip_relocation, big_sur:        "2812b6ad04327a361ce27dce8f411e400685e313a1629ff3029cfc77f495a2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a78a278272985777b060648601630421c8b4fceeb1176b65498229f057213bb"
  end

  depends_on "pyqt@5"
  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "QtPy" do
    url "https://files.pythonhosted.org/packages/ad/6b/0e753af1197f82d2359c9aa91cef8abaaef4c547396ffdc71ea6a889e52c/QtPy-2.3.1.tar.gz"
    sha256 "a8c74982d6d172ce124d80cafd39653df78989683f760f2281ba91a6e7b9de8b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
