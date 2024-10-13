class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/63/37/8f5ee72905948757f284e7a4fea1cd8b7203f13e57d2cf4917f2f1afa7a8/mackup-0.8.41.tar.gz"
  sha256 "49f929d502b3efbc01b5a206af6cff877447ac5821591b2a9231cbf42d97b17a"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "48147c55dcef0d94cd60ca788872d0eb45f504b5f661b32a1ceb6da73164e6cc"
  end

  depends_on "python@3.13"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mackup", "--help"
  end
end
