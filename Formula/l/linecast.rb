class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/3d/2a/1f2b5c7e460fe8d3f94873e836309567d49dbce02cc44dc407d745774da4/linecast-2.10.2.tar.gz"
  sha256 "3ae653e1778e757c7e2599ccb962b8574050faca24e9750ed071ad09ce55ac1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1686413a9a801ebb1b269b7b68a4e706f53783150197ab1fe78a1666eea8836e"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linecast --version")

    output = shell_output("#{bin}/linecast sunshine --location 43.657,-70.258 --json")
    assert_match '"schema": 1', output
    assert_match '"sunrise":', output
    assert_match '"sunset":', output
  end
end
