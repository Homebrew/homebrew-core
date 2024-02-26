class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://github.com/pgxn/pgxnclient/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0d02a91364346811ce4dbbfc2f543356dac559e4222a3131018c6570d32e592a"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44ff65d97f5481826e4963c3efaf758cdf6b20f6ec1ea7a15e198c6f91c9740e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36c3aef93ead993b2db8de5fcc9dc66f0e433938c17acd8c55d37dac2b6e0908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03c6ce799197f4f86f827ba75864555b5a512443b95e06cc160a28dbf3dcad41"
    sha256 cellar: :any_skip_relocation, sonoma:         "e00942c2867b45d3d0bd9e6cfc78c2b556dce24c73be0090ae3611e36b28881f"
    sha256 cellar: :any_skip_relocation, ventura:        "a9183ce3151aa765c62333b3423c2d6c75fa32af81d748dedd68a6486c93bbb9"
    sha256 cellar: :any_skip_relocation, monterey:       "7f846a0accf04fed36d5ba5173ceff9a48d38c4365d585ed3f186434b4dcd00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27e1ad1cc23034ff7976ab14da529ffc621a47c5256ce17275eeb961d44b4008"
  end

  depends_on "python@3.12"

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages(python3)
    inreplace libexec/site_packages/name/"__init__.py",
              "/usr/local/libexec/pgxnclient", HOMEBREW_PREFIX/"libexec/#{name}"
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
    assert_match version.to_s, shell_output("#{bin}/pgxnclient --version")
    assert_match "#{HOMEBREW_PREFIX}/libexec/#{name}", shell_output("#{bin}/pgxn help --libexec")
  end
end
