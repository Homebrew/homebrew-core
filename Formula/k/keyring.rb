class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
  sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb97de4f89e2a7c81bddd8695a8a4ec626214554c1578f8d6839e923ae948c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abb97de4f89e2a7c81bddd8695a8a4ec626214554c1578f8d6839e923ae948c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb97de4f89e2a7c81bddd8695a8a4ec626214554c1578f8d6839e923ae948c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a6ba9b6306faa11ba267c8ba8a6d53fe78c7ee0e5be0afb71c2dc90b86c90f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4f8ef8b6c8b613770c1804e258f25f7d751c1a7ec414b59a0643cb8d52c9235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f8ef8b6c8b613770c1804e258f25f7d751c1a7ec414b59a0643cb8d52c9235"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on "cryptography"
  end

  pypi_packages package_name:     "keyring[completion]",
                exclude_packages: "cryptography",
                extra_packages:   %w[jeepney secretstorage]

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/32/8a/ed6747b1cc723c81f526d4c12c1b1d43d07190e1e8258dbf934392fc850e/secretstorage-3.4.1.tar.gz"
    sha256 "a799acf5be9fb93db609ebaa4ab6e8f1f3ed5ae640e0fa732bfea59e9c3b50e8"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/5a/3e/837067b970c1d2ffa936c72f384a63fdec4e186b74da781e921354a94024/shtab-1.7.2.tar.gz"
    sha256 "8c16673ade76a2d42417f03e57acf239bfb5968e842204c17990cae357d07d6f"
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
