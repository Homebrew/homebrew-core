class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/de/96/fd5b083d1517d68721865092b0d86eaeee33150bca4c0ee1bf4d931b8f9f/pipdeptree-2.9.3.tar.gz"
  sha256 "d0049795a78c600bce97663a4d0ae3ebc212f7ccc2f1bd3efef910b7e8bf4591"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b3ed53d50cd1508c7b1ae665536622883901d9533e9c0199a2da075a9de1eda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e662b70900e7a9441517a9f54b6f61280d931cb4d5e6fd580a57fe9b0f4bdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbf16873ff5fcf5b0326c5f8a0ad71ca19973e5b3ac46dbfba50f0e797e1bd41"
    sha256 cellar: :any_skip_relocation, ventura:        "e526c20b6dc36bee74e717bd9a213399064947b7ed90d4010568f8a600dc25d6"
    sha256 cellar: :any_skip_relocation, monterey:       "d288fb21a32fa91cb653701ef23f7ffbb30a3b5f852dcedd533439a371531669"
    sha256 cellar: :any_skip_relocation, big_sur:        "77f738a8234a08ca61f0496cecdb12cf0cc972267cf2daa26efe090a0240b045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b6b601837495b4bfa67aabb3ba27a440ecd7121051e24fb42c96ab5a19455d0"
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
