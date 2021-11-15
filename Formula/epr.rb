class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/7f/4c/caab0fccc12990aa1a9d3ceaa5c7aeab313158293c8386c032e2e767569c/epr-reader-2.4.11.tar.gz"
  sha256 "5e931653ff954ca8e9fc734efa1e0c0a49512fe2a8652f83a6ca63a8d1c4f2af"
  license "MIT"
  revision 1
  head "https://github.com/wustho/epr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d91cc2d45112cc563aa030bbb735bf2fa55b0bd3fc81f664ea6bb842fda5c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99d91cc2d45112cc563aa030bbb735bf2fa55b0bd3fc81f664ea6bb842fda5c9"
    sha256 cellar: :any_skip_relocation, monterey:       "0023f8d76b76e28ed7622996d26dd6efd074c6da864598fd4dffa98c77f6f7d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0023f8d76b76e28ed7622996d26dd6efd074c6da864598fd4dffa98c77f6f7d3"
    sha256 cellar: :any_skip_relocation, catalina:       "0023f8d76b76e28ed7622996d26dd6efd074c6da864598fd4dffa98c77f6f7d3"
    sha256 cellar: :any_skip_relocation, mojave:         "0023f8d76b76e28ed7622996d26dd6efd074c6da864598fd4dffa98c77f6f7d3"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
