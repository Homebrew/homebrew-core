class Honcho < Formula
  include Language::Python::Virtualenv

  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/65/c8/d860888358bf5c8a6e7d78d1b508b59b0e255afd5655f243b8f65166dafd/honcho-2.0.0.tar.gz"
  sha256 "af3815c03c634bf67d50f114253ea9fef72ecff26e4fd06b29234789ac5b8b2e"
  license "MIT"
  head "https://github.com/nickstenning/honcho.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9156231ae4d87e5ec1dadf38d3251849012f02358f8b7461eb165d770963ddb6"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Procfile").write "talk: echo $MY_VAR"
    (testpath/".env").write "MY_VAR=hi"
    assert_match(/talk\.\d+ \| hi/, shell_output("#{bin}/honcho start"))
  end
end
