class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/c5/47/b0d329f026c31e20072ea9c3343deb738a20de51cc17ed94700890376f49/archey4-4.13.0.tar.gz"
  sha256 "66888425ed89647441f7b4dbbd582f55416e76d9dae86e9e9a4b4226febb71f6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a533ce21021e9fdab9171f8926c07c5a1e7a37199c5cbe939ce6eb9ee38f6d69"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a61e23a65173021839e70aaf664c7fc92ebdff24b975c685fecd8aa23746453"
    sha256 cellar: :any_skip_relocation, catalina:      "fdcf88893069bd62b09894b39dc01c1d8fc27e48f14ef9125735db74d44ad86f"
    sha256 cellar: :any_skip_relocation, mojave:        "8c41763022d97b6780e5de02d9deba4d1e896170951edbfe883d0b5d37be6f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1169e3370902278f58eef29a5da616dcf0852b91639ced4dccb6f74fe5d81b2b"
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
