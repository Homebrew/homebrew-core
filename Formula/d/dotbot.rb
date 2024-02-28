class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/04/8b/0899638625ff6443b627294b10f3fa95b84da330d7caf9936ba991baf504/dotbot-1.20.1.tar.gz"
  sha256 "b0c5e5100015e163dd5bcc07f546187a61adbbf759d630be27111e6cc137c4de"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5661e9dac979f6db4ef8b6e706760a3a8074eaef1c6392ccaed4f16c1c00a76f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cb6a2ad7940036bb57761ffe18721e31030c7c6ee04b3e9832104a97635a775"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3380d9d9eca82439203f6c0345c9da8ce7329e4b4f6a82302c5d5a21642429"
    sha256 cellar: :any_skip_relocation, sonoma:         "392a9f422ed098cfb4a74583e8ec35e25b4b15878b5e7d67e0f8f3eb5c268a8c"
    sha256 cellar: :any_skip_relocation, ventura:        "1eda9f858bfb0204494b0c92a5a935623facc04f8de683384fc8580911b3f971"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e6cd25f6bfd6344431ad6328191958de1926a1d5ef8b3b654db84533f128a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "539fa1cd7ed33c35dd997a97469887478a25319149f1f1e2bc3c5b43238e9546"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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
