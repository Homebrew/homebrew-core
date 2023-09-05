class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 6

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "485a041e54166f986f97aaa0d6e06d36c3cef6246fe1074a3772f8e8a8190d3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "485a041e54166f986f97aaa0d6e06d36c3cef6246fe1074a3772f8e8a8190d3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "485a041e54166f986f97aaa0d6e06d36c3cef6246fe1074a3772f8e8a8190d3a"
    sha256 cellar: :any_skip_relocation, ventura:        "e3afbad672d7e15d741a1efeb98b8f77a75ae88ad1168534df18e1d1dc2feee5"
    sha256 cellar: :any_skip_relocation, monterey:       "e3afbad672d7e15d741a1efeb98b8f77a75ae88ad1168534df18e1d1dc2feee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3afbad672d7e15d741a1efeb98b8f77a75ae88ad1168534df18e1d1dc2feee5"
    sha256 cellar: :any_skip_relocation, catalina:       "e3afbad672d7e15d741a1efeb98b8f77a75ae88ad1168534df18e1d1dc2feee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a604a7445ae519d1529349c4ad8f93c1fbb73c4cf1015ce0ba2019e4ceead273"
  end

  depends_on "python@3.11"

  conflicts_with "putty", because: "both install `pscp` binaries"

  # Fix for Python 3 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/957fd102811ab8a8c34bf09916a767e71dc6fd66/pssh/python3.patch"
    sha256 "aba524c201cdc1be79ecd1896d2b04b758f173cdebd53acf606c32321a7e8c33"
  end

  def install
    virtualenv_install_with_resources
    share.install libexec/"man"
  end

  test do
    system bin/"pssh", "--version"
  end
end
