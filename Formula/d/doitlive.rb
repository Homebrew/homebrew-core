class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c4/bb/96c5bb76723fcfd7031482817717e5b55441ae66b7fd7dedfa0e1c7bfaf1/doitlive-5.2.0.tar.gz"
  sha256 "041bbdf197c36b2a497c4d0a69dac53a777a77564b57ac02d4777d6058d170fa"
  license "MIT"
  head "https://github.com/sloria/doitlive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "617b5c471d1a6e15b4be87778b0bab4c7811fb176fbaa6c637429b9cbe2b5b16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ce4414162588b46a35d4e767960f2fc1fc110c3494192922c2b3ca37a9c531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4d485ce8cade1b9593b9d146453feb92f1c6a234361ab0fb5f3398da0e58f39"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a750f68ab7bf0565b741d2cddfa33f70251f3cc3c72aa2678db154c2fd1c53e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c5a126d527f40d7c9ba71cb7d2c71efed0ab1b194ff178a2646251184c59c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356a45cdfbb119cbafff8827283722c93c341814ff458572cb564f8ddfe902c1"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "click-completion" do
    url "https://files.pythonhosted.org/packages/93/18/74e2542defdda23b021b12b835b7abbd0fc55896aa8d77af280ad65aa406/click-completion-0.5.2.tar.gz"
    sha256 "5bf816b81367e638a190b6e91b50779007d14301b3f9f3145d68e3cade7bce86"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/30/ce/217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cb/click_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"doitlive", "completion", shell_parameter_format: :none)
  end

  test do
    system bin/"doitlive", "themes", "--preview"
  end
end
