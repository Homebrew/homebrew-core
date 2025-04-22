class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/08/14/4932a8aee6df2f266c748f88d27a455719d04ca5cf723d5630b7fb215d61/dunamai-1.23.1.tar.gz"
  sha256 "0b5712fc63bfb235263d912bfc5eb84590ba2201bb737268d25a5dbad7085489"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07b34f53d10977d68acd14c04017be4df1e554f22e4050929c58ed95ceb1937f"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
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
