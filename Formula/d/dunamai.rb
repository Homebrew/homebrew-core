class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/54/22/7f46b0146ef614cd6f80e4bcb188dabe33e90b4e0af028e16f597f5826ad/dunamai-1.24.1.tar.gz"
  sha256 "3aa3348f77242da8628b23f11e89569343440f0f912bcef32a1fa891cf8e7215"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "269b3b6b072addd2141d0430e7d3fcc6c95c400821db6b8b079a8ec0c56f7bed"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
