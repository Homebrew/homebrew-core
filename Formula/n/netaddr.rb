class Netaddr < Formula
  include Language::Python::Virtualenv

  desc "Network address manipulation library"
  homepage "https://netaddr.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
  sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  license "BSD-3-Clause"
  head "https://github.com/netaddr/netaddr.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "acba9aa564cf46a13bd5fa82a51e00991ac1891a986a52ab4ee3d48a53cd910f"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/netaddr info 10.0.0.0/16")
    assert_match "Usable addresses         65534", output
  end
end
