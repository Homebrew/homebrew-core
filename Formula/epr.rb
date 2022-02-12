class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/c6/d7/3af4967567358fc5e6573a961ebe262179950fd5030ea1d4ee5efda1a76a/epr-reader-2.4.13.tar.gz"
  sha256 "e9fc3a8053e307cbf6aa1298c78678786329eb405f14e971f9888f69a7950212"
  license "MIT"
  head "https://github.com/wustho/epr.git", branch: "master"

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
