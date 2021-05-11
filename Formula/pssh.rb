class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7e13419d61916a39cc1dfdca7d41e75b83ad569e752e706660a61bf5d27116d"
    sha256 cellar: :any_skip_relocation, big_sur:       "6840ae494e87f8913579af27d25d7324608df3b52769041ca608a22851271688"
    sha256 cellar: :any_skip_relocation, catalina:      "97b41f49d31808abac8379f9d5891be7cecff34bc183a42b0f6fd5ae1d9fe835"
    sha256 cellar: :any_skip_relocation, mojave:        "2755e4052daf1641f2db79119443ea4552da5db3c578ed9dd779c86f96b35a78"
    sha256 cellar: :any_skip_relocation, high_sierra:   "3eab96d7837cfab4b2c28ad5458e1c68ceb0d75c480e87613ca1872e58b2bf55"
  end

  depends_on "python@3.9"

  conflicts_with "putty", because: "both install `pscp` binaries"

  # Fix for Python 3 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/957fd102811ab8a8c34bf09916a767e71dc6fd66/pssh/python3.patch"
    sha256 "aba524c201cdc1be79ecd1896d2b04b758f173cdebd53acf606c32321a7e8c33"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pssh", "--version"
  end
end
