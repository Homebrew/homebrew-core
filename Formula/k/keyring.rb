class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/a5/1c/2bdbcfd5d59dc6274ffb175bc29aa07ecbfab196830e0cfbde7bd861a2ea/keyring-25.4.1.tar.gz"
  sha256 "b07ebc55f3e8ed86ac81dd31ef14e81ace9dd9c3d4b5d77a6e9a2016d0d71a1b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c6b028c3aec8396f3233f17171ab5fff359787116441db573513018ba54f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c6b028c3aec8396f3233f17171ab5fff359787116441db573513018ba54f1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3c6b028c3aec8396f3233f17171ab5fff359787116441db573513018ba54f1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecb752c5828e49757c0f2c7a3d0289a8e1faeba012ef11e64efbc78937223796"
    sha256 cellar: :any_skip_relocation, ventura:       "ecb752c5828e49757c0f2c7a3d0289a8e1faeba012ef11e64efbc78937223796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426d318c86185229459162e2181843aa46ee8001d05ba3c924799efda713e7e3"
  end

  depends_on "python@3.13"

  on_linux do
    depends_on "cryptography"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/ab/23/9894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013/jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/51/78/65922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178f/more-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/a9/e4/13bf30c7c30ab86a7bc4104b1c943ff2f56c1a07c6d82a71ad034bcef1dc/shtab-1.7.1.tar.gz"
    sha256 "4e4bcb02eeb82ec45920a5d0add92eac9c9b63b2804c9196c1f1fdc2d039243c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"keyring", "--print-completion", shells: [:bash, :zsh])
  end

  test do
    assert_empty shell_output("#{bin}/keyring get https://example.com HomebrewTest2", 1)
    assert_match "-F _shtab_keyring",
      shell_output("bash -c 'source #{bash_completion}/keyring && complete -p keyring'")
  end
end
