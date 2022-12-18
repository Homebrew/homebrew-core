class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/7c/40/5af5a63afb366e825998d7e618c9331661582e9366da2c21c1e1973e90c3/dotbot-1.19.1.tar.gz"
  sha256 "17a770bfbf72deaddd5c054d26a8c2353ad145ed61c8de9d898134b825696e6b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87a12d128d6b818c686dcfed8f3303256f5ae06b99535e83e60eaf505885a8e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e69e86421ab5c05c270cbcc228a5e0756d0d016c204ef6d1a3be5cf4b57f250a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "423dfff4e1cab4c57c73d8636c28e611ced0ebfbcad10fe222497de2c7138c6e"
    sha256 cellar: :any_skip_relocation, ventura:        "a27e69770f183088be7484f9d45bf62b23676da7f11ed47822fd7900df31a9e8"
    sha256 cellar: :any_skip_relocation, monterey:       "ef6c5cd693bbfb4d3f1bac46042143460f071b488ab008b1f761db1f99d986e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "44ac111a5f85630d40605cc5a924283a332bf2a8d8dc0b3a5e626c771d286c7e"
    sha256 cellar: :any_skip_relocation, catalina:       "965c56d812816e5257fa6fc1380b3a7a63dd205c473358f73a12fe590031749f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a93db285c5f1670d5904594702bf19bab0429cde0cda6cd0f73ae740e6d51b1"
  end

  depends_on "python@3.11"

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
