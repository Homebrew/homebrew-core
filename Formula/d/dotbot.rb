class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/04/8b/0899638625ff6443b627294b10f3fa95b84da330d7caf9936ba991baf504/dotbot-1.20.1.tar.gz"
  sha256 "b0c5e5100015e163dd5bcc07f546187a61adbbf759d630be27111e6cc137c4de"
  license "MIT"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sequoia: "6b5fd41ab24db6af662b8217218aa3bd7523063c70abd5650100a54eded95e79"
    sha256 cellar: :any,                 arm64_sonoma:  "8cc72a4463c1afbc99c19b1b1964de99d61474a18fa8f1ffa9c4d6aa3ccacd8f"
    sha256 cellar: :any,                 arm64_ventura: "deac30197e6a87753ae61dca9ae576130e23915f999748514995a8788a870091"
    sha256 cellar: :any,                 sonoma:        "552e887f6394e9c256b59f7170c791547d37a515951da566ce2ebb48a9753cad"
    sha256 cellar: :any,                 ventura:       "57fa5346b8a2e02360991b688a9d87357c9ddbaa0561529e6a272fc80e01539d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76a7e7b29a4ad883e46ea2e5c87a00436397d43d27439ecc69704b45d7b1235"
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
    (testpath/"install.conf.yaml").write <<~EOS
      - create:
        - brew
        - .brew/test
    EOS

    output = shell_output("#{bin}/dotbot -c #{testpath}/install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_predicate testpath/"brew", :exist?
    assert_predicate testpath/".brew/test", :exist?
  end
end
