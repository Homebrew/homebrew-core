class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/fd/10/1c7c74fd7e6072a5dc0f981d69dfcf7acf6bc7f12593b3a7c3d232f569d5/pipdeptree-2.35.2.tar.gz"
  sha256 "5f338ca966f0596c089245324dd6b27031073746d345a6b2b7594450bea82c4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db10c17e4d572ee682e6c78a234ed7e159245714284ba8e109be86c47ef598ae"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
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
