class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/6a/e5/640afbc106bb4e836228977d9593227148b1f7ba365172bd160c4d315c66/git-up-2.0.2.tar.gz"
  sha256 "ce1bc2285393145d0c287de271ecea9f5302b6103be92263077e4c4a1fcd58cb"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2729ba1c5fff79743b8e46e04a6dd5839184c80fe57f3e4df1768f558ba4e970" => :big_sur
    sha256 "0e261cbb6ac35ca4c905238155cfa7566f8ff38f686e553a140f7813fd38cbaa" => :arm64_big_sur
    sha256 "e02c94526d58af22a560a80d981fea7c537f5faa7253e27f216cbb07ddb2eddf" => :catalina
    sha256 "3638f5357ceb0aa375c334b1586efd376d524c0134c0d89b738145e890f1e3d0" => :mojave
    sha256 "aee7d37c874a7bab06dcb113eddacd69b38f538cd6a880894a41fed90ec55840" => :high_sierra
  end

  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/d1/05/eaf2ac564344030d8b3ce870b116d7bb559020163e80d9aa4a3d75f3e820/gitdb-4.0.5.tar.gz"
    sha256 "c9e1f2d0db7ddb9a704c2a0217be31214e91a4fe1dea1efad19ae42ba0c285c9"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/85/3d/ee9aa9c77a3c0e9074461d2d8da86c3564ed96abd28fa099dc3e05338a72/GitPython-3.1.11.tar.gz"
    sha256 "befa4d101f91bad1b632df4308ec64555db684c360bd7d2130b4807d49ce86b8"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/75/fb/2f594e5364f9c986b2c89eb662fc6067292cb3df2b88ae31c939b9138bb9/smmap-3.0.4.tar.gz"
    sha256 "9c98bbd1f9786d22f14b3d4126894d56befb835ec90cef151af566c7e19b5d24"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "git", "clone", "https://github.com/Homebrew/install.git"
    cd "install" do
      assert_match "Fetching origin", shell_output("#{bin}/git-up")
    end
  end
end
