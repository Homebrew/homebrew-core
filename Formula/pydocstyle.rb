class Pydocstyle < Formula
  include Language::Python::Virtualenv

  desc "Python docstring style checker"
  homepage "https://www.pydocstyle.org/"
  url "https://files.pythonhosted.org/packages/da/1f/cd8bb9e67bf4030e183f480b4e6dc917f99b618caebb03f019a6b30a5fc2/pydocstyle-6.2.0.tar.gz"
  sha256 "b2d280501a4c0d9feeb96e9171dc3f6f7d0064c55270f4c7b1baa18452019fd9"
  license "MIT"
  head "https://github.com/PyCQA/pydocstyle.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11591f3472ce083fd8f56068da5a7441954d66f4afad42500b6650b2a3814d9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79d16bee35a3b67c8953b524bc40924a9ae6f362116d9c8716d73c5816574b76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f3596d75b4c7799708e2af41e2e55202ee09554b74e535e0be90f946a88c710"
    sha256 cellar: :any_skip_relocation, ventura:        "4191bca163eb8ced72cacb8fde273314ca8be9ccfb03d8115500a04ed1563093"
    sha256 cellar: :any_skip_relocation, monterey:       "f36bd57c1c1b64bea7d05f66c93150c897a9c49fb4923d50d847b25856e2a0dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "af34d12a6df41fb57f8cbe3f75b41c001300fca417a40a5e3a3a34524cb9479d"
    sha256 cellar: :any_skip_relocation, catalina:       "efe358f510174eb6d12b900d692e54b740425f85dbd1390db3d57b618e8278b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a9fce6d97ce3168628b5316a0f398cbad89deb2e1069e3f2f2b3f9dd8797a8"
  end

  depends_on "python@3.11"

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring():
        """  extra spaces  """
        pass
    EOS
    output = pipe_output("#{bin}/pydocstyle broken.py 2>&1")
    assert_match "No whitespaces allowed surrounding docstring text", output
  end
end
