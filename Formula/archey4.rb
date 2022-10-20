class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/7e/6b/ccab7e74a8c9cf79a82912508d741bbb78219c307cc0daef219c2dc802c9/archey4-4.14.0.1.tar.gz"
  sha256 "349e462d530491f17526441261bea3d0cd1b2430b69f5eaa03054961b918e1d1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f83cd355b238c93798c245716c81e65df0a45eb99ffb93077e8e62a30d7b638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bcaea881ca64bf8ccf41768293e18a48d9c3c148219991dd8fdfeb705be39f7"
    sha256 cellar: :any_skip_relocation, monterey:       "e265ca71d41ccf1f46a1676a496f914d826f3083bdc7554c4502b694363f9f75"
    sha256 cellar: :any_skip_relocation, big_sur:        "636718fb8c5a8f0f05da5a3c5fd8b2a2d3557cb03f1f1b19b9dffae06581e3b7"
    sha256 cellar: :any_skip_relocation, catalina:       "4fedd9109bcc00c0369dda4badd972fa9e9ef2d74d1274396699f56c81820d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "501eeafc552d57176afd68388e45b735cd8fcb58ffaf7ac845eb8cf28b5ed2e9"
  end

  depends_on "python@3.10"

  conflicts_with "archey", because: "both install `archey` binaries"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/b5/7e/ddfbd640ac9a82e60718558a3de7d5988a7d4648385cf00318f60a8b073a/distro-1.7.0.tar.gz"
    sha256 "151aeccf60c216402932b52e40ee477a939f8d58898927378a02abbe852c1c39"
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
