class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/c9/11/b9cb698d1172faedaa21dfe31e5034a24c4dd3bafe87aeeee6e74fd856e4/git_cola-4.11.0.tar.gz"
  sha256 "50be00d2f9197db8dd6118e13f6ab472857436dc8d0149db30a5e1a119d712e9"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67b824ff935438bba393678532d055651b43f46bafb0f5aca21c8fb2618f76a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f67b824ff935438bba393678532d055651b43f46bafb0f5aca21c8fb2618f76a"
    sha256 cellar: :any_skip_relocation, sonoma:        "41883996494401689e2af58ec5d9cffb5db24af9478c2865cb781eaee67360b1"
    sha256 cellar: :any_skip_relocation, ventura:       "41883996494401689e2af58ec5d9cffb5db24af9478c2865cb781eaee67360b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67b824ff935438bba393678532d055651b43f46bafb0f5aca21c8fb2618f76a"
  end

  depends_on "pyqt"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "polib" do
    url "https://files.pythonhosted.org/packages/10/9a/79b1067d27e38ddf84fe7da6ec516f1743f31f752c6122193e7bce38bdbf/polib-1.2.0.tar.gz"
    sha256 "f3ef94aefed6e183e342a8a269ae1fc4742ba193186ad76f175938621dbfc26b"
  end

  resource "qtpy" do
    url "https://files.pythonhosted.org/packages/e5/10/51e0e50dd1e4a160c54ac0717b8ff11b2063d441e721c2037f61931cf38d/qtpy-2.4.2.tar.gz"
    sha256 "9d6ec91a587cc1495eaebd23130f7619afa5cdd34a277acb87735b4ad7c65156"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
