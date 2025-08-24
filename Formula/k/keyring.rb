class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/70/09/d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37d/keyring-25.6.0.tar.gz"
  sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6751512859d21a591e9a129a2ae7280e4d7eebec85895469fac19bb600b8bf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6751512859d21a591e9a129a2ae7280e4d7eebec85895469fac19bb600b8bf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6751512859d21a591e9a129a2ae7280e4d7eebec85895469fac19bb600b8bf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d5f42d57266df2bf90fdb718f3f4c2198a37afe1dd27d7331ddfd8e6d7eef2"
    sha256 cellar: :any_skip_relocation, ventura:       "72d5f42d57266df2bf90fdb718f3f4c2198a37afe1dd27d7331ddfd8e6d7eef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a823152b79eed15240ea7ac5456139abcb62dd5c5c9a2b875b2fdfd965a9e6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a0f4e4498be2d9179f945f490d44fda8e5621171f578c7610e71d9e2ad70d45"
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
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ce/a0/834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09/more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/5a/3e/837067b970c1d2ffa936c72f384a63fdec4e186b74da781e921354a94024/shtab-1.7.2.tar.gz"
    sha256 "8c16673ade76a2d42417f03e57acf239bfb5968e842204c17990cae357d07d6f"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"keyring", "--print-completion", shells: [:bash, :zsh])

    # Build an `:all` bottle by removing macOS-specific comment
    prefix = libexec/Language::Python.site_packages("python3")
    inreplace prefix/"keyring-#{version}.dist-info/METADATA" do |s|
      s.gsub!(/macOS\s+\(Homebrew.*/, "")
    end
  end

  test do
    assert_empty shell_output("#{bin}/keyring get https://example.com HomebrewTest2", 1)
    assert_match "-F _shtab_keyring",
      shell_output("bash -c 'source #{bash_completion}/keyring && complete -p keyring'")
  end
end
