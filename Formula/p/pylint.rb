class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://pylint.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/38/c9/0bde4152a05a7686b431ce216fe3f3698b0c0d94c20bfa256dd935b608f6/pylint-4.1.3.tar.gz"
  sha256 "9928603068edfa0d1a3c167f174b099d4b97c3db75d32d0fcdd029770b4713a9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81e14d31863356f77bf4ba015e33cab5e1f60e58ac442e116ece12b57b600f09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "81e14d31863356f77bf4ba015e33cab5e1f60e58ac442e116ece12b57b600f09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81e14d31863356f77bf4ba015e33cab5e1f60e58ac442e116ece12b57b600f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d75da858c50dfceba718649e91bedb33b983f80c1e9bd4cc5574f35b8708ceda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d75da858c50dfceba718649e91bedb33b983f80c1e9bd4cc5574f35b8708ceda"
  end

  depends_on "rust" => :build # for `isort`
  depends_on "python@3.15"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/2d/87/5732fa68bf100a095cfcbd108f919220d995db99e1a7502b8119a869fd62/astroid-4.3.4.tar.gz"
    sha256 "d515a105722b72098bbe82d430d65e635f742b6cbac3bdfaf8b7c188b87c5e39"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/81/e1/56027a71e31b02ddc53c7d65b01e68edf64dea2932122fe7746a516f75d5/dill-0.4.1.tar.gz"
    sha256 "423092df4182177d4d8ba8290c8a5b640c66ab35ec7da59ccfa00f6fa3eea5fa"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/da/cf/068066b8fdab91cd40bcd63e483137908710a3d25a4d3a01b538be45d9d6/isort-9.0.2.tar.gz"
    sha256 "d2298980ce44350f11d9d24c8150eaef1883431ec203dddbb4e9b5c3ceb54c70"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  def install
    virtualenv_install_with_resources

    inreplace libexec/"pyvenv.cfg", HOMEBREW_PREFIX, prefix
  end

  test do
    (testpath/"pylint_test.py").write <<~PYTHON
      print('Test file'
      )
    PYTHON
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
