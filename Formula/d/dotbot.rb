class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/9b/ca/b3ed58bef83a0e25a913b7f77794aa848ad2d7b976c452488b5fe268086b/dotbot-1.23.0.tar.gz"
  sha256 "909c1b7875c00f5d11d61797e4f1885c4d7a1b4db2290b262a71a0457913a5c6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f57c6ab4737f39805aa4706d246179291d8e971c2858ae59c4635e28b69c77fb"
    sha256 cellar: :any,                 arm64_sonoma:  "63457f9e551e14ebfb5f487deec01a1258088000038779877610d93b209cdf71"
    sha256 cellar: :any,                 arm64_ventura: "002e18bc8793a3520b7ec7cadc1872e2a1daa6636a3e1b54402e7ae050c0859d"
    sha256 cellar: :any,                 sonoma:        "c7a687a9367ed1226b8d89143871ec1db4d62737fdf0f590031c508a44227b6a"
    sha256 cellar: :any,                 ventura:       "04ae107967d76a538865b21c38fc6d5301f91e91188bef63550476ecd0a3c537"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6e639112ed4982b4932d6ed0fb2699b0f7ab399075bb2e0708286494a4f5e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02960ddbd7a42420b428e29ef13a4ea2a74ca60847bd111f2fbb15e5c16e61f6"
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
