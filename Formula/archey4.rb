class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/54/60/212f5018cc4671fd6b288faf2018ff74e8fcf68703c72e31bcea9ca6217a/archey4-4.13.1.tar.gz"
  sha256 "80abe635c31ae02750c873c12621db56403641db9a04f8a775eb22012fa90f21"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0148a6dd47f4293ae1506680fdfec56d76fdd9bdbfbb4c76da521c79fc55a39"
    sha256 cellar: :any_skip_relocation, big_sur:       "be860b92249bc5132f9ef0e4ae96acb063e3043de10382794a3dd28d7d8140a8"
    sha256 cellar: :any_skip_relocation, catalina:      "1ac1530bfc83776938983bf397bf38cc5a5108e2fa4824e457a4ecda882258b8"
    sha256 cellar: :any_skip_relocation, mojave:        "a75ec9eb60d3c796e5194c27dd5fd3f0de0aac132fea3b9d2509c32a13b078ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "379e5d93a626a8dcf02e010efcf80dae9a54030ed89009972197e663c99617ef"
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
