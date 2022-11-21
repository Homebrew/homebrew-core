class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/7e/6b/ccab7e74a8c9cf79a82912508d741bbb78219c307cc0daef219c2dc802c9/archey4-4.14.0.1.tar.gz"
  sha256 "349e462d530491f17526441261bea3d0cd1b2430b69f5eaa03054961b918e1d1"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e671e4010ac734aeea3a07bd8c73f112e4b7e2ec63c56d0a604e9270897c3f7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82e733ff22e9672f4c481ffba502e8b91e3dc417857e5ee004948cdebbe864e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c15c7c4c86f81cb92cafde76dce1bde8887a0b42aecc674ffc5b24603c4efbd"
    sha256 cellar: :any_skip_relocation, ventura:        "eb70e113b2746752602a8fd3baa347d2aac1760a921b0096b22079ae2c4784a5"
    sha256 cellar: :any_skip_relocation, monterey:       "e37569399a3494c36af12545a0d11220a772770feb8817b8e93a6e82315b20cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "351ec9affc5272bf3b4ca9a16f27bd113f61c526f495488aff3c13872b1b6fef"
    sha256 cellar: :any_skip_relocation, catalina:       "e6fac4e403690a15257ae925992f0b6ce496994de2ad3fc35128b4918598b789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d08071b13a32148196c4affa001eb5c9c3684571e09e22b0ebbbc89112994ab"
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
