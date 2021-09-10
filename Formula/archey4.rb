class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/54/60/212f5018cc4671fd6b288faf2018ff74e8fcf68703c72e31bcea9ca6217a/archey4-4.13.1.tar.gz"
  sha256 "80abe635c31ae02750c873c12621db56403641db9a04f8a775eb22012fa90f21"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef7f2d3afefe0ab6b360de49ab593b1889338a243ab34ec259a468680369657a"
    sha256 cellar: :any_skip_relocation, big_sur:       "73b88da9996449f3e24959fce41adc4614cbf84e2b561da792105d9faf370786"
    sha256 cellar: :any_skip_relocation, catalina:      "860b9bbe915630f8f17e31e2e78ae6a6772d277c2949d26e25a37113d6835a53"
    sha256 cellar: :any_skip_relocation, mojave:        "af0ba191fafce835871c3f054aa37a822b12ac5eb0a82459adf96be5c2be8e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec5410a13db4510efa484b0497ee6f39c81100e4ade702df47fa53680b74b3c6"
  end

  depends_on "python@3.9"

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
