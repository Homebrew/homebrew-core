class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/db/06/45e8c09c600c0647aa549b66e08f8dcf15203f81efbdd8f0bf4a784bf8e2/archey4-4.13.3.tar.gz"
  sha256 "8c81ad0267d6d4689357d27e274fa142e10a8e619184bfafd9e57d9a8a720848"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62f3bd15c1f45182b47649a8dbbfe3a2fb6d26d444678f54df9eece728f3d415"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37bfb5ef166056a64862eedca01e9ac44c041d44cd4a8af763af0fa86f329178"
    sha256 cellar: :any_skip_relocation, monterey:       "13e7e4f687ed7e264d9c3eb853d7b6b09e64b7e26545a2e2ecb628bb03a1703f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2330a9c7e085631becc1c981ed4a1b66061146fbf354f04ab4884f70c5486e01"
    sha256 cellar: :any_skip_relocation, catalina:       "6e6fd5ad1252c9ee3d7ee09cf48b0105447c24502a4ab939290a878a9e3bd438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48cf0d9341c959f192513de80ea013d6d00e4dbeda72c3ac640a756cc227049"
  end

  depends_on "python@3.10"

  conflicts_with "archey", because: "both install `archey` binaries"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a5/26/256fa167fe1bf8b97130b4609464be20331af8a3af190fb636a8a7efd7a2/distro-1.6.0.tar.gz"
    sha256 "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/archey -v"))
    assert_match(/BSD|Linux|macOS/i, shell_output("#{bin}/archey -j"))
  end
end
