class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/7f/4c/caab0fccc12990aa1a9d3ceaa5c7aeab313158293c8386c032e2e767569c/epr-reader-2.4.11.tar.gz"
  sha256 "5e931653ff954ca8e9fc734efa1e0c0a49512fe2a8652f83a6ca63a8d1c4f2af"
  license "MIT"
  head "https://github.com/wustho/epr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e950edea32308a9414ba884c6b766c49653178af54276840b65cda6a04fb674"
    sha256 cellar: :any_skip_relocation, big_sur:       "4db6010289370b66c85d18b9cb629cf2e06bd516c87338be3e0121b75fca3c85"
    sha256 cellar: :any_skip_relocation, catalina:      "4db6010289370b66c85d18b9cb629cf2e06bd516c87338be3e0121b75fca3c85"
    sha256 cellar: :any_skip_relocation, mojave:        "4db6010289370b66c85d18b9cb629cf2e06bd516c87338be3e0121b75fca3c85"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
