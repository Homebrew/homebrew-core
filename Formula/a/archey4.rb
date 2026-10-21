class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/a7/bd/f70b613520c3f683eff6b9ffe5a31ba142bcc1b206db3181606b8e440193/archey4-4.15.0.0.tar.gz"
  sha256 "1cf158ab799fa8a5d15deab0a48df306d2788c81de44d0242c3ab1dfa84865ac"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfa6d2f78c76ed507c5c5b26fa024c65d421410f13d64df70cc67ce5543382a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0154792e1fb2a7f5b04c5851e9ad65ad3d026c3f21668ad217ee299356de68cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c39d4d277039c216edf01fed49f92a5c8784c105a8352985f27fbeb1f287ba0"
    sha256 cellar: :any,                 arm64_linux:       "82bf31327d381962b0fa2ab6b24c385b3039120b74f3df3c85c01f11b7085d73"
    sha256 cellar: :any,                 x86_64_linux:      "9d8014e67b533b8e8331b86f9fe52b4a9d1b71145651fc76a69da78d48d62ee0"
  end

  depends_on "python@3.15"

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

    # Skip the Disk entry, whose `diskutil` call needs DiskArbitration access the sandbox denies
    (testpath/"config.json").write <<~JSON
      {"entries": [{"type": "User"}, {"type": "Distro"}, {"type": "Kernel"}, {"type": "Shell"}, {"type": "CPU"}]}
    JSON
    assert_match(/BSD|Linux|macOS/i, shell_output("#{bin}/archey -j -c config.json"))
  end
end
