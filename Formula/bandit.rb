class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/1a/99/499f1aba344a3b71042d959529264855caf3409f07c3dfcfa1689a7bf6b8/bandit-1.7.1.tar.gz"
  sha256 "a81b00b5436e6880fa8ad6799bc830e02032047713cbb143a12939ac67eb756c"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6461b840ba4567543e4519782873dc5eda6cc540912756aced1f2a32df7bb191"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03ab7efa2c441cebb531d26ad851e00581dee0917d76d8ae2af53b5e4fb0b3d5"
    sha256 cellar: :any_skip_relocation, monterey:       "36fb08fcb90a03e7ebefc4c9d95bb4a1b38d1ca69ba00f612370437850b46b4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "70b71b83c81f132febcf4a9717e484855a5ac0fac982bcd70161b3b4bd8ba1fc"
    sha256 cellar: :any_skip_relocation, catalina:       "fc39e5fd3d1c440f67f92e81e3b71811497444dd33c34c014a5badbd38d3be9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a18d6aa2dc0f46f6a04e27be7433729763f46c0d21682b85cdfea3cc664f6426"
  end

  depends_on "python@3.10"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/34/cc/aaa7a0d066ac9e94fbffa5fcf0738f5742dd7095bdde950bd582fca01f5a/GitPython-3.1.24.tar.gz"
    sha256 "df83fdf5e684fef7c6ee2c02fc68a5ceb7e7e759d08b694088d0cacb4eba59e5"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/69/7e/e420b9b6b06f9597827571e871f9492512701497971a4cf3f4638c03bc7a/pbr-5.7.0.tar.gz"
    sha256 "4651ca1445e80f2781827305de3d76b3ce53195f2227762684eb08f17bc473b7"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/67/73/cd693fde78c3b2397d49ad2c6cdb082eb0b6a606188876d61f53bae16293/stevedore-3.5.0.tar.gz"
    sha256 "f40253887d8712eaa2bb0ea3830374416736dc8ec0e22f5a65092c1174c44335"
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
