class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/c2/1c/25d293f113d6091412ac5dbe2eee56bad5ba97c7a4ce0ca25df91c0c3eb8/git-cola-4.3.0.tar.gz"
  sha256 "fcf8ad0886660f5bc957878655648e0701c092d0aba2ae1e8f82c73562ab874b"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8bda5f27d1c9dcdc9ccb04f98a419c3fb789f386a71e29d4e43c46b59e8294a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fab8f93876e7c07b8c037597ec9a436a7852fc1e9c72625183012df9b6ace996"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2001bc5b645ebd58905a4bb1b9e31d02eec9866e4ba261f6e6c6439991d9391c"
    sha256 cellar: :any_skip_relocation, ventura:        "50404e49d9aaea4443e5b75c2acf7377b8e78b6bf959e63379d5ed0f521f7b08"
    sha256 cellar: :any_skip_relocation, monterey:       "ba01d1c584b53ea723a5b67c889fca4798bd6a95e763654d449f7e1e5477d93a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ed38933c825da5f37eb65cde83c61b9f87613374ef851ae3fe0f7f327f76cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "288dee8ec85484d005d2cba097add13df4f6d134a1b3407b59d4b58e782d5f12"
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
