class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/99/45/f3a0541ddf67af4153da892c192bdbe0a88c66dafb669fff89f7edde110f/archey4-4.12.0.tar.gz"
  sha256 "94926dca648226830d04ac0fb72dc70f2bf3d1fa80d53da4279d2171f61aae1a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a533ce21021e9fdab9171f8926c07c5a1e7a37199c5cbe939ce6eb9ee38f6d69"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a61e23a65173021839e70aaf664c7fc92ebdff24b975c685fecd8aa23746453"
    sha256 cellar: :any_skip_relocation, catalina:      "fdcf88893069bd62b09894b39dc01c1d8fc27e48f14ef9125735db74d44ad86f"
    sha256 cellar: :any_skip_relocation, mojave:        "8c41763022d97b6780e5de02d9deba4d1e896170951edbfe883d0b5d37be6f59"
  end

  depends_on "python@3.9"

  conflicts_with "archey", because: "both install `archey` binaries"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/0d/18/fd6e9c71a35b67a73160ec80a49da63d1eed2d2055054cc2995714949132/netifaces-0.10.9.tar.gz"
    sha256 "2dee9ffdd16292878336a58d04a20f0ffe95555465fee7c9bd23b3490ef2abf3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/archey -v"))
    assert_match(/BSD|Linux|macOS/i, shell_output("#{bin}/archey -j"))
  end
end
