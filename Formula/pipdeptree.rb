class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/e2/e8/f3dc919f9fd0a00e387abcf419324f2561969189367b65a849b37e185049/pipdeptree-2.5.0.tar.gz"
  sha256 "ef17672a0ec47ae97ae9d50f98eabe209609ffd08e8b4abdc2e8e20bf499b151"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dc52dcef897a6e9c19f1b08a9aab699b9acdef30f8483b6714849cbb6e903ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d9fa136db8e828f2779da3f3589744f12c786ff05f486053ac12fc5d856ca0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8a13abcf5261c0d04502dcc8138884ae3832110544456339b42e9f53b69e585"
    sha256 cellar: :any_skip_relocation, ventura:        "53cc60d5e57f4749aa25f18f0d4c381de04a9dd8c7eced87c6a9c58da8d967dc"
    sha256 cellar: :any_skip_relocation, monterey:       "cfea8390a0f211630a70d6c78a919dad289cb172f7382500491f8a1455fd62a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0088dab8699c85549be5805b417b17bbffb9a10b065256df44cf0f26064fd6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fecc6b5e0ef0fd7be92dc6e4aff08ed2dec57c06ab51f75b51a1445f0201dc32"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
