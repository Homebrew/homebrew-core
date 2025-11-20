class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/05/4b/8308f726306d3d983323dd9bfa55e3610a07168f56ef612ecae05998ed55/dotbot-1.23.1.tar.gz"
  sha256 "b6e419a898c03d2ecaaf802af9764041ac583fc59e367bdde509640c5d193f3b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ee51eb3c9c781b874266489e72eaedde69b5835768927a0564caa07754c94b1b"
    sha256 cellar: :any,                 arm64_sequoia: "a01aca0b02a12194ab780fc68f9782048a8e07d80bf85921a308a0f2e4a4c29a"
    sha256 cellar: :any,                 arm64_sonoma:  "ef8170a154784e43ed2aa42da39277048053e5a4df02dd34edb3b76979478abe"
    sha256 cellar: :any,                 sonoma:        "9130e0815cae534f4e554b39653145bd888f54bd70224522e54d6c0ca7d53be8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f66f6e4ec5fdcdc198b6fb925ae52de5a90d44ed0da1320772f1ff6650f05c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98f397c00719cc2e5959d51c36ea47d2a0f7bc39601c9154506647b15759cbce"
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
