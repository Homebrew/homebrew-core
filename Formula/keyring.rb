class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/e0/a8/31b814a0c99118ee4db6df013925a3236fa18a914bf69202277896bf4038/keyring-24.1.0.tar.gz"
  sha256 "bd48a36612ef55505bf70e563528e3e66ba93267e344b6780cf6151f9c1eda6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93d6829c57d4b33f59fdd5e2e5643aa04ff66053c6c1e3a44f55af4b5e1f8213"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b638f625df20cdba0b1ed301dc1430e9368088b083ffc2622ec2be54c2b403a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90ead717ec792041723c2cccd78145bb4362e770e1d91d3938c64d733a3011cc"
    sha256 cellar: :any_skip_relocation, ventura:        "c39172a66cf7f5dc41d0e3d011080dd7003fc27b6649c29387580f5e5f93bc87"
    sha256 cellar: :any_skip_relocation, monterey:       "e427b121b69642b849f80e6954e5c0c4124267bf00f47dc3d323a4e3ff2b9a71"
    sha256 cellar: :any_skip_relocation, big_sur:        "af6cecf24482820aa632316083489890ed41cf54d62f20c04a7def554ec96f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3727d280bbb89754eafc9d44a674a09a2591217df1292f8b33cb1d7c3c4cf43f"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build # for cryptography
    depends_on "rust" => :build # for cryptography
    depends_on "openssl@1.1"

    resource "cryptography" do
      url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
      sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
    end

    resource "jeepney" do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "secretstorage" do
      url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a3/82/f6e29c8d5c098b6be61460371c2c5591f4a335923639edec43b3830650a4/importlib_metadata-6.7.0.tar.gz"
    sha256 "1aaf550d4f73e5d6783e7acb77aec43d49da8017410afae93822cc9cca98c4d4"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2e/d0/bea165535891bd1dcb5152263603e902c0ec1f4c9a2e152cc4adff6b3a38/more-itertools-9.1.0.tar.gz"
    sha256 "cabaa341ad0389ea83c17a94566a53ae4c9d07349861ecb14dc6d0345cf9ac5d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/keyring get https://example.com HomebrewTest2", 1)
  end
end
