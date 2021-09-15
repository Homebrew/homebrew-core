class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/d3/67/733dbf0b444d41af473238537d5ef7bd5906870f35a69ef4f7dc64e74519/dotbot-1.19.0.tar.gz"
  sha256 "29f4a461462a5ff3b1e9929849458e88d827a45d764f582c633237edd373f0af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0b6b39ce0e5810579e20cce7a7e2b244f2036eb7203240fd5b97cd03da28844"
    sha256 cellar: :any_skip_relocation, big_sur:       "e96e9f7e3ae93e6859f13479b586d971958349ca8ee4bb1d5fead64ebdcd1dde"
    sha256 cellar: :any_skip_relocation, catalina:      "3bc7bf088b33d3c024b3a04b8e89c3339a8d27a780cb1f6f0904141ea84e407d"
    sha256 cellar: :any_skip_relocation, mojave:        "1a3eea6c83af210a85c83c88460ddfa1d30b644917bbea537015e7682085158a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a49f87edf43be337908b09c6077c574aea3faa466c8a0c266219c5dbafd24187"
  end

  depends_on "python@3.9"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
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
