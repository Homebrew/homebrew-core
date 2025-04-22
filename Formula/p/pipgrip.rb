class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/40/8e/a3d17fcdab26b738c6067142461d721c03da8e627944b184bfb28ec8ae3b/pipgrip-0.10.14.tar.gz"
  sha256 "f99791cbe4819f4477237b3487bc8f69258236058f3093c5ccdfd9b157405308"
  license "BSD-3-Clause"
  head "https://github.com/ddelange/pipgrip.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "158d120e374774c7e6a9c613a19cee2e29ef587030627b7425eb86532342c2cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "158d120e374774c7e6a9c613a19cee2e29ef587030627b7425eb86532342c2cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "158d120e374774c7e6a9c613a19cee2e29ef587030627b7425eb86532342c2cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "955d231bc75581deb2be9fb31e6f6997a510784c929bd5bf1616e24c20e716fe"
    sha256 cellar: :any_skip_relocation, ventura:       "955d231bc75581deb2be9fb31e6f6997a510784c929bd5bf1616e24c20e716fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d77cf7e45e6a83a1624774b8f55dd8544ba98d037a0d3b0e82a0254aabd1b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d77cf7e45e6a83a1624774b8f55dd8544ba98d037a0d3b0e82a0254aabd1b47"
  end

  depends_on "python@3.13"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pip==25.0.1", shell_output("#{bin}/pipgrip --no-cache-dir pip==25.0.1")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip --no-cache-dir dxpy==0.394.0")
  end
end
