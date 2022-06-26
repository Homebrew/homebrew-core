class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/d3/67/733dbf0b444d41af473238537d5ef7bd5906870f35a69ef4f7dc64e74519/dotbot-1.19.0.tar.gz"
  sha256 "29f4a461462a5ff3b1e9929849458e88d827a45d764f582c633237edd373f0af"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e4681de4209b0622d9523124931dc7f8ead206d8768e8b934af4bce1149ee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e5418a009f3e05c563ada0705c6e077d56e4df49ab42f1496ef43e097dc6f1d"
    sha256 cellar: :any_skip_relocation, monterey:       "b7cf1d41236d1358f46b52827a24c323311e151839391a808472032ef6c3e1b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4eed817693537664519d582af946fa870d40c8c584b9706d9c4742ebe13ba8e4"
    sha256 cellar: :any_skip_relocation, catalina:       "1580a56ae5c22273b996866519a938da04c8fec7adc805f435399b954bebb9df"
    sha256 cellar: :any_skip_relocation, mojave:         "fdb6be14bd6a4ad73c2ca13c3f5a62cc74bb64ff507278a99d4e0b944e09dd75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e8e2840e9c40ac40da72cf275aebbc2365a21a4874b8c040109667e1c004b6"
  end

  depends_on "python@3.10"

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
