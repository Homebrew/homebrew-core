class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/6c/a1/14b70b67ea9c69e863dd65386bbc948ae34a502512d6f36e2a5a9fd5513b/bandit-1.7.0.tar.gz"
  sha256 "8a4c7415254d75df8ff3c3b15cfe9042ecee628a1e40b44c15a98890fbfc2608"
  license "Apache-2.0"
  revision 1
  head "https://github.com/PyCQA/bandit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a51a2892fce736e59144b7188c5767233040266a998a09cd568afd82049e1ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "1b1eacd9dcb2c47aa44fb744a55eb635cd213a14f34a841585dc0c46cd5d76e7"
    sha256 cellar: :any_skip_relocation, catalina:      "1b1eacd9dcb2c47aa44fb744a55eb635cd213a14f34a841585dc0c46cd5d76e7"
    sha256 cellar: :any_skip_relocation, mojave:        "1b1eacd9dcb2c47aa44fb744a55eb635cd213a14f34a841585dc0c46cd5d76e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8ec57d1f780fb44aa99e16df2f884d957eab201c5bd6cefa719c04c114527bb"
  end

  depends_on "python@3.10"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/d1/05/eaf2ac564344030d8b3ce870b116d7bb559020163e80d9aa4a3d75f3e820/gitdb-4.0.5.tar.gz"
    sha256 "c9e1f2d0db7ddb9a704c2a0217be31214e91a4fe1dea1efad19ae42ba0c285c9"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ec/4d/e6553122c85ec7c4c3e702142cc0f5ed02e5cf1b4d7ecea86a07e45725a0/GitPython-3.1.12.tar.gz"
    sha256 "42dbefd8d9e2576c496ed0059f3103dcef7125b9ce16f9d5f9c834aed44a1dac"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/65/e2/8cb5e718a3a63e8c22677fde5e3d8d18d12a551a1bbd4557217e38a97ad0/pbr-5.5.1.tar.gz"
    sha256 "5fad80b613c402d5b7df7bd84812548b2a61e9977387a80a5fc5c396492b13c9"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/75/fb/2f594e5364f9c986b2c89eb662fc6067292cb3df2b88ae31c939b9138bb9/smmap-3.0.4.tar.gz"
    sha256 "9c98bbd1f9786d22f14b3d4126894d56befb835ec90cef151af566c7e19b5d24"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/95/bc/dc386a920942dbdfe480c8a4d953ff77ed3dec99ce736634b6ec4f2d97c1/stevedore-3.3.0.tar.gz"
    sha256 "3a5bbd0652bf552748871eaa73a4a8dc2899786bc497a2aa1fcb4dcdb0debeee"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}/bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end
