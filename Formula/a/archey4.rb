class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/a7/bd/f70b613520c3f683eff6b9ffe5a31ba142bcc1b206db3181606b8e440193/archey4-4.15.0.0.tar.gz"
  sha256 "1cf158ab799fa8a5d15deab0a48df306d2788c81de44d0242c3ab1dfa84865ac"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67a20d46c2fe1dbb51cb872d3d4ebb5342aabfda48a7cfbe915c17ad948969e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51d8ab649cfb4d5dfeb23231753d9262cfa033f2c1643f0a219564a3f9832d5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2744766739856ebe780fc7388965edc612d51923c3c765033cf87ace0b0b12e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4154cfde5e161ec534f03d72f49537da940a41ef4009fce5172f07acc3ee88b5"
    sha256 cellar: :any_skip_relocation, ventura:       "cd489ed03f68abd8a88be37ea82d00cc426d3d5feabaf0b68eeda977b7da3d88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9477e1961d10803b128e9685f28fb196d08d2bcebff10b558d6ebda403e25d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "970c7db826029c191477ba09e3a7b3288e80aee797ababba472b22d9b3a483ac"
  end

  depends_on "python@3.13"

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
