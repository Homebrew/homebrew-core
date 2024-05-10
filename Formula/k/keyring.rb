class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/b8/09/fdd3a390518e3aebeec0d7aceae7f9152da1fd2484f12f1b3a12a74aa079/keyring-25.2.0.tar.gz"
  sha256 "7045f367268ce42dba44745050164b431e46f6e92f99ef2937dfadaef368d8cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d1c022ee178b0eb18932feb623c37415838b1ab3b7cdeedc4e4e09af8859474"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d1c022ee178b0eb18932feb623c37415838b1ab3b7cdeedc4e4e09af8859474"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d1c022ee178b0eb18932feb623c37415838b1ab3b7cdeedc4e4e09af8859474"
    sha256 cellar: :any_skip_relocation, sonoma:         "36b2533dd3f1c0c304cb3025bc1df5d0b4b40ad0e8eaef84d6b9d0968d80fe2f"
    sha256 cellar: :any_skip_relocation, ventura:        "36b2533dd3f1c0c304cb3025bc1df5d0b4b40ad0e8eaef84d6b9d0968d80fe2f"
    sha256 cellar: :any_skip_relocation, monterey:       "36b2533dd3f1c0c304cb3025bc1df5d0b4b40ad0e8eaef84d6b9d0968d80fe2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a26ae56650ddb9cda5637c163e7d048b0a28a32fedf35d043f7c27e2dc9d1c"
  end

  depends_on "python@3.12"

  on_linux do
    depends_on "cryptography"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/c9/60/e83781b07f9a66d1d102a0459e5028f3a7816fdd0894cba90bee2bbbda14/jaraco.context-5.3.0.tar.gz"
    sha256 "c2f67165ce1f9be20f32f650f25d8edfc1646a8aeee48ae06fb35f90763576d2"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/bc/66/746091bed45b3683d1026cb13b8b7719e11ccc9857b18d29177a18838dc9/jaraco_functools-4.0.1.tar.gz"
    sha256 "d33fa765374c0611b52f8b3a795f8900869aa88c84769d4d1746cd68fb28c3e8"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
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
