class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/7c/40/5af5a63afb366e825998d7e618c9331661582e9366da2c21c1e1973e90c3/dotbot-1.19.1.tar.gz"
  sha256 "17a770bfbf72deaddd5c054d26a8c2353ad145ed61c8de9d898134b825696e6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82a87ef5c38c91a4329bbafc6b6d4c0856e512e1334c8d39529d4964273d4a51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d406769d6bb49ca919e1db2e271d7a6e20aef5320e07ed4f1d55755f31d10a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d335163a7b3b68aaaf187ceba945a71f10067ee7bf2cbaa36e6611783f85ffa"
    sha256 cellar: :any_skip_relocation, ventura:        "ca7ab372224f4b7ec9d1f165bf2d2d6a8f3e71d59e092818cd491545657f1d3a"
    sha256 cellar: :any_skip_relocation, monterey:       "b62202266d5a89356facd76dbc1f12af470f3226f3a4cf08d2ef31b0aac52877"
    sha256 cellar: :any_skip_relocation, big_sur:        "18a39de29f61831836bc9290694da93812b6b20f6bbd851dabc3643a6219137a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44acb56ce1e862e7ee29874f32e6c0318a38d4abc54988a21557c2e35bb6580b"
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
