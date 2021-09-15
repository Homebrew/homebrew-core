class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.github.io/gitlint"
  url "https://files.pythonhosted.org/packages/3e/bd/31f661a621a22094c0f905a228142dd463dacdc71ed2b2a570956062b64e/gitlint-0.15.1.tar.gz"
  sha256 "4b22916dcbdca381244aee6cb8d8743756cfd98f27e7d1f02e78733f07c3c21c"
  license "MIT"
  head "https://github.com/jorisroovers/gitlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "415d16b4b9224c4f35e7e9d1157b369080b215757e841a1b1580e47736fe75ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d5cca443df3d7a86db359642f404da3236983165ed3bf59471b9d1262c95be7"
    sha256 cellar: :any_skip_relocation, catalina:      "102fd40cb4d4e8d5f1e1b2c23164e327dc9506f59aea5a79a81a963249c3ce50"
    sha256 cellar: :any_skip_relocation, mojave:        "427ca21ef9d7d31b021c13889b2f291e3a70740ab45d3aff36de8dec04338b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ac6012949c127b182719deae1e9098b8986fa28a5acfd9db1a0c0a566417730"
  end

  depends_on "python@3.9"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/f6/72/e8c899f0eef9c0131ffdb1bc25d79ff65c60411f831ab17d29e3809f5812/arrow-1.0.3.tar.gz"
    sha256 "399c9c8ae732270e1aa58ead835a79a40d7be8aa109c579898eb41029b5a231d"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/f6/d4/e80280b1eba9597d16144f71d12cdf62d0e66170d289880f307cf905d327/sh-1.14.1.tar.gz"
    sha256 "39aa9af22f6558a0c5d132881cf43e34828ca03e4ae11114852ca6a55c7c1d8e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Install gitlint as a git commit-msg hook
    system "git", "init"
    system "#{bin}/gitlint", "install-hook"
    assert_predicate testpath/".git/hooks/commit-msg", :exist?

    # Verifies that the second line of the hook is the title
    output = File.open(testpath/".git/hooks/commit-msg").each_line.take(2).last
    assert_equal "### gitlint commit-msg hook start ###\n", output
  end
end
