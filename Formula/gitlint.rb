class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.github.io/gitlint"
  url "https://files.pythonhosted.org/packages/df/b5/04355d3abe6b372e6bae36864ec7b659012343da437b595895637713f90f/gitlint-0.15.0.tar.gz"
  sha256 "aae7e966d765a818d941398f2d3aff6ec7f30a7251dd5c915846b7e82f4f7776"
  license "MIT"
  head "https://github.com/jorisroovers/gitlint.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "52ac0738eaf1ee717e838a7a2d2c2e8c4745f281bafc846a054be2526567c411" => :big_sur
    sha256 "8131d633d12e717a5cffd63fcd8717d1f7de4660c0ecea17e39a35cee982d9ca" => :arm64_big_sur
    sha256 "79dacaaf2f45dedcca1fb05efbf8c84d37f85996db920a4a675ceff724a8110f" => :catalina
    sha256 "dbb9d4e5bbabaa3a75ea7d38df6cb46ad51f95e5378591068f397884cee9ceb6" => :mojave
  end

  depends_on "python@3.9"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/ec/74/1cf2d9912921cebdba3fa954949206c8aa159c9cc803b88140fb227f8a0e/arrow-0.17.0.tar.gz"
    sha256 "ff08d10cda1d36c68657d6ad20d74fbea493d980f8b2d45344e00d6ed2bf6ed4"
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
