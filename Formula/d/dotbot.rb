class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/04/8b/0899638625ff6443b627294b10f3fa95b84da330d7caf9936ba991baf504/dotbot-1.20.1.tar.gz"
  sha256 "b0c5e5100015e163dd5bcc07f546187a61adbbf759d630be27111e6cc137c4de"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "7c915e69334d507f8e07d710e01b9a0962e187d9a02d590ef6167a6afc5aea62"
    sha256 cellar: :any,                 arm64_ventura:  "f7c36c60cad2f30b4c5f9d8d56bfcdbda2388338f2a56fdc010106682023a201"
    sha256 cellar: :any,                 arm64_monterey: "d61bef91100b62a3921baabef23f4bd85ed4c0b5086b20fbe387c243622330d7"
    sha256 cellar: :any,                 sonoma:         "5912bf49d4f31ac781030eebb2817ea2f1b21119080dc3325d1758a2ab2f7512"
    sha256 cellar: :any,                 ventura:        "9237f9d6d443b4f661a9dd696a32472a0bdc0ca444bb0df892cac1a03690ec09"
    sha256 cellar: :any,                 monterey:       "744736579abe5adf4efebc62512b71c32c6949e1bc0acc5e2a055fd9945b804a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84e71d8131a14f8ef5284ef4c71b2b0a9de2742d715da2e70f5c55fb7454c63d"
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
