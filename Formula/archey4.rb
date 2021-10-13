class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/54/60/212f5018cc4671fd6b288faf2018ff74e8fcf68703c72e31bcea9ca6217a/archey4-4.13.1.tar.gz"
  sha256 "80abe635c31ae02750c873c12621db56403641db9a04f8a775eb22012fa90f21"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b64e809af1410ea24a70a70cf456c371431e319e11a43d0e140c26dfc851d8b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "118c8187c10d7dd1faa00f94b6db72533b55def50e9647384418fed7ec689f8f"
    sha256 cellar: :any_skip_relocation, catalina:      "3ed0d01ccfa0e97b971e396983bbde2aae4138b12cf2fc692783a6728bc82575"
    sha256 cellar: :any_skip_relocation, mojave:        "65f3d3531d86aa457bfd916249d2ac66ebde7cd5df0c30424f50f74b5a0b1f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d999a978e484ede3993368de394ccf2e329204b206f5f2e2eba4626e6d6d368c"
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
