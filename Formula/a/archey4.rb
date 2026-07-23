class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/a7/bd/f70b613520c3f683eff6b9ffe5a31ba142bcc1b206db3181606b8e440193/archey4-4.15.0.0.tar.gz"
  sha256 "1cf158ab799fa8a5d15deab0a48df306d2788c81de44d0242c3ab1dfa84865ac"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b51742b76a0d2c6fa1f889d22c4c1346ff2a1c696adff0e27936ef1b113ee84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f89f2d74d626422931410d34c7d8b5399ea0751098945065b0225c45751df928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "892ee32d2fee5bb6c81d0ce7f9d09856eea40d5a1cc47ef3e11d7ff9f534e6d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "72a8d23ac8b71a3d221173b763cbc0b24741585707134ba3b5a1da295014c721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2903334f800483b711c76502cde2a16ed6a44c8d2ce4ddeae17a9299a230dad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcf85f57e5437fd832700cf479064e7c1d5ee3582abfe235d9b42c51ffb92f70"
  end

  depends_on "python@3.14"

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
