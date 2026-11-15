class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/ce/99/905f34404698d54de29fbc1dcbb9fdc4b1bbd4b5b30207750ff5ad5b5c69/dotbot-1.24.1.tar.gz"
  sha256 "83def50fa1625530066f105b88c2dc1c61e27536433488a12324eb0b55a14730"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "747b71ad01cbcc93da523220e9eec7032f2951d2290d8ebcb1c38a9bc51e8bc3"
    sha256 cellar: :any, arm64_tahoe:       "60dad598a032220dedcd96532ac8b38f5aa7f9150ac1cfad03ac1688696d2d6a"
    sha256 cellar: :any, arm64_sequoia:     "cb264c02e2061ecf7b6b8b6ee5bd3925af7381cf13b357edea1aa37d95dd9aba"
    sha256 cellar: :any, arm64_linux:       "e50a0ef9a58f91d4de17d52fcdde5f7aef6906c8324eca1d71cc627c539e50e3"
    sha256 cellar: :any, x86_64_linux:      "7d2e5fee46fa922ea245d4e3397c693e9de8a55c008f0283480bd5ea7da59fc2"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"install.conf.yaml").write <<~YAML
      - create:
        - brew
        - .brew/test
    YAML

    output = shell_output("#{bin}/dotbot --verbose -c #{testpath}/install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_path_exists testpath/"brew"
    assert_path_exists testpath/".brew/test"
  end
end
