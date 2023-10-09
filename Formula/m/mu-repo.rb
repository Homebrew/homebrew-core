class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/fc/3f/46e5e7a3445a46197335e769bc3bf7933b94f2fe7207cc636c15fb98ba70/mu_repo-1.8.2.tar.gz"
  sha256 "1394e8fa05eb23efb5b1cf54660470aba6f443a35719082595d8a8b9d39b3592"
  license "GPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32f19f981a0b5f89591c01a8b27f6b96dce2363003e03c431d948920f0b6f648"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22ac2c05ef44e73cb0adc960c1b30c38bb399991b208fc14f894889b114ca928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b17c86fdaf0137925c71fa893004c40e6598017bd9d0a8b09eb8a8f28d63d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c25efe6df304f7ac9c3444ec7aa37f4e36ae15e00ac3f26c2ce3315f24534abc"
    sha256 cellar: :any_skip_relocation, ventura:        "a510913eebdff79d1b3d9a170d55e4c181f186be04c3df7c4d3231d981cad49a"
    sha256 cellar: :any_skip_relocation, monterey:       "2647a75ac88d39730d9266f536bd64e484d2426436119a1a65923eb1e766c8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c678e1101a3df4f587013a5d2da95c8a6a34f6892a5267d9e3f5019cf9da97"
  end

  depends_on "python@3.12"

  conflicts_with "mu", because: "both install `mu` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/mu group add test --empty")
    assert_match "* test", shell_output("#{bin}/mu group")
  end
end
