class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/8f/9f/c94c929cde5b1a295bb382e5ac139734166bd4a2c153c9bc98049e44436e/dotbot-1.21.0.tar.gz"
  sha256 "f3dffc21bd603ae13d4097438c702e0b0f0ff0416d028ed20fa8906f39ec8953"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40779ef3cdfd085e415cc914e7fa56a46ed451ceed8ae0ed4e688f16c50acad8"
    sha256 cellar: :any,                 arm64_sonoma:  "0e2936c7ad172ce6eba810f0fadf695c7bfa3420a47e8433ec61be5262ab4a33"
    sha256 cellar: :any,                 arm64_ventura: "6e42ee1ac22fc0faf6e1f704e1cfb1ee98007ef5f7443ebba158ce752431a3c1"
    sha256 cellar: :any,                 sonoma:        "1bd9f76f9ad0b514602aebb0b30c3d69db0b04f066990bab62a20cffe87c207d"
    sha256 cellar: :any,                 ventura:       "65cd5598599cec59f69d94163616856daede84aad13d253e0d2a362d357e1460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86b1ef5d51283f85ad579f4f32277a3ec7926f5357e3af375ae330574917e6e1"
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

    output = shell_output("#{bin}/dotbot -c #{testpath}/install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_predicate testpath/"brew", :exist?
    assert_predicate testpath/".brew/test", :exist?
  end
end
