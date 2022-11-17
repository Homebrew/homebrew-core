class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/89/a3/35f7460cfaf7353ceb23442e5c250fda249cb9b8e26197cf801fa4f63786/git-up-2.1.0.tar.gz"
  sha256 "6e677d91aeb4de37e62bdc166042243313ec873c3caf9938911ac2e7f52a0652"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "351a9b821afa45f737e515561a3e876b6bf75f703a71ee6ed75ff678394e8b5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af40353a01a614d4bc465ba70b08b2d4f00eede7a76aeb0bbdd79e04d6dcc55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9b22898c5e56844d47859b35f7842aa87f0d3d7a9793e296f549b8417bbff4b"
    sha256 cellar: :any_skip_relocation, monterey:       "d2027e4b933862b4ab7a4f92cdee2f8e03d5e22c52ad79d418449106d7259657"
    sha256 cellar: :any_skip_relocation, big_sur:        "84219a6f7fceaf201b657f33a4a652fc079a477bb7b5dab94d08ddc3630e945d"
    sha256 cellar: :any_skip_relocation, catalina:       "ab5b2d0a723a980dd62caa137bdf09f618cbafbe739d1ede82078e374837713e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a98812c666201fcb9409bd3fbfeb79ddd7838283ef579892e09c0b7dbf4d71e"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/22/ab/3dd8b8a24399cee9c903d5f7600d20e8703d48904020f46f7fa5ac5474e9/GitPython-3.1.29.tar.gz"
    sha256 "cc36bfc4a3f913e66805a28e84703e419d9c264c1077e537b54f0e1af85dbefd"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # Remove on next release
  patch do
    url "https://github.com/msiemens/PyGitUp/commit/68e937058fce5a1a764c15ff24c05d9539496c57.patch?full_index=1"
    sha256 "3f6b624e0c1b384cfaa8d4e39abf0d35624492db47f85e88c0219cfa26eab0d8"
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
