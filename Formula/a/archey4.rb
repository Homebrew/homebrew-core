class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/dc/9a/8a0921ed2df4da26197f98b0f6a8b3af1fa232cc898a13e719e9ed396e95/archey4-4.14.3.0.tar.gz"
  sha256 "31ce86c6642becd11a9879a63557ed5cef3f552cd9cfe798299414a9c5745056"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b518af92de8367f515be97385419b0f1917143c5d9486ae9f360ac813ca27e50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32b8f3ec7f10da235ed8547dab063d706069721b52ebcda71807f91fbe7ed938"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0226ba7100274cb0edadaac048ad27feb0989ba11dc508460d72bc14bdf15850"
    sha256 cellar: :any_skip_relocation, sonoma:         "330dc2fbf198aee47c86f4692664f2f1fbdce4e8fc2e42a7f858b19de7c3d7f2"
    sha256 cellar: :any_skip_relocation, ventura:        "0edc05acda306481d567574e99c06ce07a2e6b3440fd5ea84b5abb0e0dc5132e"
    sha256 cellar: :any_skip_relocation, monterey:       "c0694a7459bc572be8473d4c8fc2403659fc9bb3ada4b37a86fb780d08c31e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93aabca2dc5ac82a21a9b0ed445d0ecf267aa936288f7d08a3616fd544e4548b"
  end

  depends_on "python@3.12"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
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
