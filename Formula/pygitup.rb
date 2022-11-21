class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/55/13/2dd3d4c9a021eb5fa6d8afbb29eb9e6eb57faa56cf10effe879c9626eed1/git_up-2.2.0.tar.gz"
  sha256 "1935f62162d0e3cc967cf9e6b446bd1c9e6e9902edb6a81396065095a5a0784e"
  license "MIT"

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
    url "https://files.pythonhosted.org/packages/19/da/ff1f0906818a5bd2e69e773d88801ca3c9e92d0d7caa99db1665658819ea/termcolor-2.1.1.tar.gz"
    sha256 "67cee2009adc6449c650f6bcf3bdeed00c8ba53a8cda5362733c53e0a39fb70b"
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
