class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/04/8b/0899638625ff6443b627294b10f3fa95b84da330d7caf9936ba991baf504/dotbot-1.20.1.tar.gz"
  sha256 "b0c5e5100015e163dd5bcc07f546187a61adbbf759d630be27111e6cc137c4de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "003084192d911a6e12b04602c1a46d1c3173b004af90904d6d0a14ede0a1ab21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "603a0f873b8df8b86ceff4b95c645d5b34f366b5c6e136ef2be8703ec1133a69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62bbea915d56536fa5a451b49de231332c22f2b891dc3f96a9a623093d7784b1"
    sha256 cellar: :any_skip_relocation, ventura:        "9aa4f0d66b27d5918557fefb8b5357240761ee96841d32a9b8c503a00e67ff7f"
    sha256 cellar: :any_skip_relocation, monterey:       "45f6f9e0fcc859eab836d76505355259875aaae190b6225cd338eab4d401f706"
    sha256 cellar: :any_skip_relocation, big_sur:        "df34a064a15982bf92c9539c61a94418211e648d19fce4c6cab656ca6214a680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f2ccdcae669a30e68b3dfcb15a11c3c5dd5aae86920447d35af1df285f7f39"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

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
