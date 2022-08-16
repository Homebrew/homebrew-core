class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/24/9f/908b11390cfa5bdf60d7f55f05168d12093021bcad2dd95a9c94ff661d80/mackup-0.8.35.tar.gz"
  sha256 "c12068f6d056ffd6c6b3c0ab623864656d18012ee5634f806d89eacd65436565"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "238d45c8bf17b952c8dd3293a6ca60767cc3f51b6a52a219a85317b398dd4cf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "238d45c8bf17b952c8dd3293a6ca60767cc3f51b6a52a219a85317b398dd4cf2"
    sha256 cellar: :any_skip_relocation, monterey:       "a1e102e917fa6c9fff2a76fa68333cb151f9ee822f00c105a0565222f486a3e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1e102e917fa6c9fff2a76fa68333cb151f9ee822f00c105a0565222f486a3e7"
    sha256 cellar: :any_skip_relocation, catalina:       "a1e102e917fa6c9fff2a76fa68333cb151f9ee822f00c105a0565222f486a3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a92c39f5ac40a8c02a26a6b877f720a0802d910f87eaf8995d8ef817dfb4b3"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
