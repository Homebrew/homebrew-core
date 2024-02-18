class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/ff/d5/ddf2f6edc7a6da2e31071340c38b2d71c3a8b99ffccf3652bb6965a8ab52/pipgrip-0.10.12.tar.gz"
  sha256 "4ff9bee6158eed27fe5b609c3504eaaea57709401592057e88656663457fc9d7"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e2545baeb5169e14787bcde0e2ca4692dffad5236d1eac5ef2c6bb4e66e9e94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac2738df7ab4c8d9cdc151653a53f77a4f22983471fe34fd7495f65408baf2ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82e35ef1395ce034390b3e27d1b5b7aaef7952f136fa41267892af32f86539d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "040b93ee65392e66b4748e0b6fd0320d1e19e3a4e0bd8ca35efc5b412bc15dfb"
    sha256 cellar: :any_skip_relocation, ventura:        "7d4623510e536d8993c24a67755a35976ecb6f230ecb1506800234d67802aec7"
    sha256 cellar: :any_skip_relocation, monterey:       "664881b65b793f9b36ebaa1d25e6be956140192b22fab607eb54ab38ade6814e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4628af5dd00a834ee26483c9d89f2d7d6150a2a64379ed2a81ea55fa2df1866"
  end

  depends_on "python@3.12"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
