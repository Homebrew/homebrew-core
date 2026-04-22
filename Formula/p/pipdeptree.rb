class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/6b/f0/fafc4fa3c489c15c0f94c4df89a48fb59fdee2428db64e1adaf4cef94863/pipdeptree-2.35.1.tar.gz"
  sha256 "4bbcffe7d1edead00f5ca64c265b0bf902c919f872637e055924c3bea8c615d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e552e9f9dc3b18f924304b2c279016e1d03fb4bb7b5c6f241fe883b869bccf62"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
