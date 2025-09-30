class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/05/4b/8308f726306d3d983323dd9bfa55e3610a07168f56ef612ecae05998ed55/dotbot-1.23.1.tar.gz"
  sha256 "b6e419a898c03d2ecaaf802af9764041ac583fc59e367bdde509640c5d193f3b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b14c5627586521cf6390fa5c21ca52c792766f4d3d4e7af45b6e0514b8e28306"
    sha256 cellar: :any,                 arm64_sequoia: "be2cdb7ea682b1e1e80be3c35a99d3c6fe4f9ed8c092947906f6ad34500b00d2"
    sha256 cellar: :any,                 arm64_sonoma:  "4a6df17f0e78bde62efd47b191afb7ab06f471fe4bc8b3c2e621e8832f8a7c53"
    sha256 cellar: :any,                 arm64_ventura: "bee58a558d1c9e7db2dcd3f2092a82366bd87e0e3828b782c70ebdef79acdc91"
    sha256 cellar: :any,                 sonoma:        "c5d3c4cd7e5a6d48e01b811910ce5993f11a15ca2e751f7f91df0f75899189d3"
    sha256 cellar: :any,                 ventura:       "34ced83c25613d7962ec02e3fa1cc743b9a42c8c4a9cd02546362deb35317101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "534e2e0087255d7558b1bc0f84192d181c85c389b1f3c54aa982e8c320f4786a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f95f6647267c2121a5f386ed902b95e0e8ed067bb3c0b705096199210139f53b"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
