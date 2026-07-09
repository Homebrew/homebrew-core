class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/ce/99/905f34404698d54de29fbc1dcbb9fdc4b1bbd4b5b30207750ff5ad5b5c69/dotbot-1.24.1.tar.gz"
  sha256 "83def50fa1625530066f105b88c2dc1c61e27536433488a12324eb0b55a14730"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f11fc268afc48eb84dcec075be866a777a427124d4cabf10b82b4cbf43c53b70"
    sha256 cellar: :any,                 arm64_sequoia: "9e80c9348d4858e59425bd693c38d6a81b2bc16322d23d637285f02644c42fde"
    sha256 cellar: :any,                 arm64_sonoma:  "3ba6b8474ba3866d41188e1ac3dbdf372d4ab6220844dd3304db422ffa0ee9d0"
    sha256 cellar: :any,                 sonoma:        "6bca4a4f996a6f36ac5cf0c3094a9ed1d9aa2130059c41b98eb2981462541caf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f9c9f4dc510d699b4f238d3da190e5cb2a499ddf28540aad8b8676c5e460df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2428eb6bb83ca72e5597648724b4c8e8f1f82e45ed0f61ed8a574e7085e6ba7c"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

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
