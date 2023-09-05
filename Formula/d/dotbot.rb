class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/17/dd/e63106d944dfac3d2092ec5935c69f73ac806138586df719b3ce72027066/dotbot-1.19.2.tar.gz"
  sha256 "ae4e232fd47085a647826589d1c5bf2bf426c04f777365dc7e1e0626cdac2f01"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b23059c3f02ae977edb8d441e2bbced81bdab79a95536513da66f1abdff484c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9351a6eefac2cede6abaf020565377a7422e7c6c25aa7867c70854dd5fde974"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ba3d93f89a9d18f2aae1b2912fdc2e2403a8e6c7081615b7c9b383309f5e2b0"
    sha256 cellar: :any_skip_relocation, ventura:        "5a457fdcc35c27362a5665483e06caf6f4f9639534e163de5512eede90f7c72b"
    sha256 cellar: :any_skip_relocation, monterey:       "ac07981f760438071cd6a18b78d376aef09760e770e5e45eb86fdc32b80f5204"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d9d0546d8f640f8e701ed59cfef810485715c4b41885f99d1a47de5e8f74c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "955cf9550e00bfc1b9388ba68349d9d2d926f495a656a1bb48fb1b0e38a9ec00"
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
