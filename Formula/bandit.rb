class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/39/36/a37a2f6f8d0ed8c3bc616616ed5019e1df2680bd8b7df49ceae80fd457de/bandit-1.7.4.tar.gz"
  sha256 "2d63a8c573417bae338962d4b9b06fbc6080f74ecd955a092849e1e65c717bd2"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0091642260daeca5125bf05626f6f12e1a08c34dcb34b438292fc3dec6f43e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "437e9a8b75bdb52fc8055d4cb4572d38b6b181098b830dbef842fe645d804f3a"
    sha256 cellar: :any_skip_relocation, monterey:       "efa468bed53d8dda0bf3ec53197255efc489d5c9642e1ad1a0907e73320ba1f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f7744b613f90fb4214a7afaa429ab13f352f0470b18bb8515e38c337b662160"
    sha256 cellar: :any_skip_relocation, catalina:       "6478334ce46c9b0ee01ec83598ea89fe2e043bc418def4068ba7df76015d30ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809c32197ec9e1632c990f0f29b4b70d0c5f656f1a5395524a205a58cfee9dca"
  end

  depends_on "python@3.10"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d6/39/5b91b6c40570dc1c753359de7492404ba8fe7d71af40b618a780c7ad1fc7/GitPython-3.1.27.tar.gz"
    sha256 "1c885ce809e8ba2d88a29befeb385fcea06338d3640712b59ca623c220bb5704"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/51/da/eb358ed53257a864bf9deafba25bc3d6b8d41b0db46da4e7317500b1c9a5/pbr-5.8.1.tar.gz"
    sha256 "66bc5a34912f408bb3925bf21231cb6f59206267b7f63f3503ef865c1a292e25"
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
