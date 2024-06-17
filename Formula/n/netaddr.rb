class Netaddr < Formula
  include Language::Python::Virtualenv

  desc "Network address manipulation library"
  homepage "https://netaddr.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
  sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  license "BSD-3-Clause"
  head "https://github.com/netaddr/netaddr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "172666490f282e237f0226fc0351afdc61761e33a5b03a6ad2a2fe6894861b49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "172666490f282e237f0226fc0351afdc61761e33a5b03a6ad2a2fe6894861b49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "172666490f282e237f0226fc0351afdc61761e33a5b03a6ad2a2fe6894861b49"
    sha256 cellar: :any_skip_relocation, sonoma:         "172666490f282e237f0226fc0351afdc61761e33a5b03a6ad2a2fe6894861b49"
    sha256 cellar: :any_skip_relocation, ventura:        "172666490f282e237f0226fc0351afdc61761e33a5b03a6ad2a2fe6894861b49"
    sha256 cellar: :any_skip_relocation, monterey:       "172666490f282e237f0226fc0351afdc61761e33a5b03a6ad2a2fe6894861b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ac44529ab10d5361449ac9335565ce86e1f5b03b13e1fa6111c37203765a048"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output(bin/"netaddr info 10.0.0.0/16")
    assert_match "Usable addresses         65534", output
  end
end
