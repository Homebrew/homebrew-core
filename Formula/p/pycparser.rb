class Pycparser < Formula
  desc "C parser in Python"
  homepage "https://github.com/eliben/pycparser"
  url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
  sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e97e86fe65b91b4493be72bcea986e8cf44b26a74edcbd126dd20b388a7fb86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "386608d130ded5215a4581f4bc9faa384b22ffa8d29972db4fb1ec5086668b72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1a401dc340c66e412223b363a9697779dbbc343b3d07d13cd148f1d9b7bcdef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96626d0c0f59bc978001b7c4f65fd375e010a1a56f48990146bc048abdf5c2e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b56541f1d460e7c3c5699579d758cde3d415304dfdc1854e7826c927bcb795f2"
    sha256 cellar: :any_skip_relocation, ventura:        "3171ff81665d2e51335e472ca4cd4394481190ac065f97020486bf8348f695ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4a0fb1fed03f11666cf6c78c1650a33779a39b8f6bbb3387c34fdfecf9304fd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c23784cd0cf2e5c01d062546556e0a8eebfbca75d7c659c0a4e30f9354886019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e7b30c1fb7012bc60b3e53ab282d2da37cf614282c4eec8cc11c686de441f8"
  end

  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
    pkgshare.install "examples"
  end

  test do
    examples = pkgshare/"examples"
    system python3, examples/"c-to-c.py", examples/"c_files/basic.c"
  end
end
