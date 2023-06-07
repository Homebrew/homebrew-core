class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/f7/af/f674dccea083f60f39649de5104bc5e2120d9540b3e136578510407d16a7/archey4-4.14.1.0.tar.gz"
  sha256 "cb321e67154c730726c3757672a46c3af9b2ffe1af7f295830f9c061fd7a69ea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8313a95885e3e88849580727c3b8c9077373ff48d462eef1d5571b3347708883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae692f19361034c48820cbee73476185bba034c6418c816e34a02420e9eb3746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c815b2741e778f9cca0d9ba6e08bf4793b2f938b82d15f47e1341c7a5c38c7a"
    sha256 cellar: :any_skip_relocation, ventura:        "5eed1e7424385b25d06095d70efdef76282c81349ca554daea2fb5e6cac96a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "7bd96471606b7a7efafd4b55876db1fd9e326b2e435a3d1294d0d4414ddcdac8"
    sha256 cellar: :any_skip_relocation, big_sur:        "81278aa510c3a73f8f0359c4f0d1367b01ad4f235bc17421b5ccf4004d126535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3088805d286b345d9845cc40b6ee1646fd7f74af21647583b68b06e3342cb2f"
  end

  depends_on "python@3.11"

  conflicts_with "archey", because: "both install `archey` binaries"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
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
