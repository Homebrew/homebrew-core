class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/30/10/abee071c1d52b2bca48be40fe9f64ca878a77e0beef6504597e8c9c1ed84/pylint-3.2.6.tar.gz"
  sha256 "a5d01678349454806cff6d886fb072294f56a58c4761278c97fb557d708e1eb3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ab45fe6677720c8a7c62ed765203301b8605dbe6028fb76ddd860e507af1fdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ab45fe6677720c8a7c62ed765203301b8605dbe6028fb76ddd860e507af1fdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ab45fe6677720c8a7c62ed765203301b8605dbe6028fb76ddd860e507af1fdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e1d732ff081e5f5796bcb96bad6066996eba5b315b9c3e16fba2aaff81a9403"
    sha256 cellar: :any_skip_relocation, ventura:        "0e1d732ff081e5f5796bcb96bad6066996eba5b315b9c3e16fba2aaff81a9403"
    sha256 cellar: :any_skip_relocation, monterey:       "0e1d732ff081e5f5796bcb96bad6066996eba5b315b9c3e16fba2aaff81a9403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b67c85f744968a9f37e6fbf4aed2b037743c2008f1de36becc10ec3a4136b297"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/9e/53/1067e1113ecaf58312357f2cd93063674924119d80d173adc3f6f2387aa2/astroid-3.2.4.tar.gz"
    sha256 "0e14202810b30da1b735827f78f5157be2bbd4a7a59b7707ca0bfc2fb4c0063a"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/17/4d/ac7ffa80c69ea1df30a8aa11b3578692a5118e7cd1aa157e3ef73b092d15/dill-0.3.8.tar.gz"
    sha256 "3ebe3c479ad625c4553aca177444d89b486b1d84982eeacded644afc0cf797ca"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/87/f9/c1eb8635a24e87ade2efce21e3ce8cd6b8630bb685ddc9cdaca1349b2eb5/isort-5.13.2.tar.gz"
    sha256 "48fdfcb9face5d58a4f6dde2e72a1fb8dcaf8ab26f95ab49fab84c2ddefb0109"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4b/34/f5f4fbc6b329c948a90468dd423aaa3c3bfc1e07d5a76deec269110f2f6e/tomlkit-0.13.0.tar.gz"
    sha256 "08ad192699734149f5b97b45f1f18dad7eb1b6d16bc72ad0c2335772650d7b72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
