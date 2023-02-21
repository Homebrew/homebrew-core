class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/a3/85/4b6267f7fecad59f69b7f2e131c6896019912e3977fc4a0396c0cb562623/dunamai-1.16.0.tar.gz"
  sha256 "bfe8e23cc5a1ceed1c7f791674ea24cf832a53a5da73f046eeb43367ccfc3f77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "018a4e9bedbeb897a52d483dc68bb566815e634846dc5afb5d59a1bcc1e8191e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3de569352a308460ad073a21c7a72691dc47f42f4a813a7b4fa71b56f2f4c8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d57ac1ea859a32fc998897154e9fcb7322acf43810d0e9483fa2d6dee8f1fc7"
    sha256 cellar: :any_skip_relocation, ventura:        "a0200b0d97cdd5a703cb0b218f0863533446c071b4eb0d1d18d9f670612de4f5"
    sha256 cellar: :any_skip_relocation, monterey:       "4afb6132b06fdd324f9b3f4d1414c3355a7e9fee4a806c8d70600f9cf49eccf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a3944533cb1b349b62fcce5fe4e79c09aeacd106ac122f3b1094eb00be12023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4bb24920e553d5081ef96f374e531ecbd485dd1bc567442be510a5531446f2"
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
