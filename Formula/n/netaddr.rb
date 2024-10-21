class Netaddr < Formula
  include Language::Python::Virtualenv

  desc "Network address manipulation library"
  homepage "https://netaddr.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
  sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  license "BSD-3-Clause"
  head "https://github.com/netaddr/netaddr.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "956b7206ec84b8593a134a61a6239ebd708be777740155aee63d8f8d0731c2d9"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output(bin/"netaddr info 10.0.0.0/16")
    assert_match "Usable addresses         65534", output
  end
end
