class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/73/ce/07022e6c05e5a192afeec24fe10bd24d16665f656a283704c320a671476d/pipdeptree-2.32.0.tar.gz"
  sha256 "0342e53df0df8e74d158bfa8bac01061725da4f05e204aebc5010b425ab9a926"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d2cfb010adad6e0007e244748ee3244ddc871ceef64476ba2a5e9e91ea40ca8"
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
