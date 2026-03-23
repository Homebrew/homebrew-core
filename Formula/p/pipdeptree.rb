class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/c7/c4/c240c9405e5f31180864e8640bf3d13767d80804d1498be871e772999af9/pipdeptree-2.33.0.tar.gz"
  sha256 "69fea485429ae697d0a97c2f4ea950bd489417622f2a75747c50f5349eeaee46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4dab79aedd5693868b53ed55c7959de08f3cecc127a2ffa6f6550d0b44f73eba"
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
