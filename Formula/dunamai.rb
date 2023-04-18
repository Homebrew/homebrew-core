class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/a3/85/4b6267f7fecad59f69b7f2e131c6896019912e3977fc4a0396c0cb562623/dunamai-1.16.0.tar.gz"
  sha256 "bfe8e23cc5a1ceed1c7f791674ea24cf832a53a5da73f046eeb43367ccfc3f77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c4204d358885f27d6de6ed77fd0336e704a2631e44967f976274d6e6576d08a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9273ab108881fe453076d86ca877cf65f5bad38a03c15705dc926ee871ac7564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "384c8d969a95427b143d314634187c60ac28ea8bbd0d33722b68d4a6843d481f"
    sha256 cellar: :any_skip_relocation, ventura:        "45fa238049a432348aad737ce70ae745f0ed2687623118cada00806a09128ad5"
    sha256 cellar: :any_skip_relocation, monterey:       "d2055773827aec50e583881261f9c95309454e4de573abf693687b2690fa1358"
    sha256 cellar: :any_skip_relocation, big_sur:        "e616d2f808ffdd3b64ad0f6dfb8e6cf0910fe108f4f86f3f12868e5b6480a9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2eb36512553e61968e063640abea85d294713fb74b67a45e8b7dfa88d321c73"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end
