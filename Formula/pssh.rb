class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436c285c33f75a1cd82f2d6b17065baa9400f13c9b9e1b8ac1baf2155891ed24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "436c285c33f75a1cd82f2d6b17065baa9400f13c9b9e1b8ac1baf2155891ed24"
    sha256 cellar: :any_skip_relocation, monterey:       "705c0d12faaee33a41a1ba3ce77d8abfba8a1da5001f9afe9e4bbc434c38289e"
    sha256 cellar: :any_skip_relocation, big_sur:        "705c0d12faaee33a41a1ba3ce77d8abfba8a1da5001f9afe9e4bbc434c38289e"
    sha256 cellar: :any_skip_relocation, catalina:       "705c0d12faaee33a41a1ba3ce77d8abfba8a1da5001f9afe9e4bbc434c38289e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "726391939b6cbc3c6e3b8060991db660018dbedbd6be786409cc6e086d2039fc"
  end

  depends_on "python@3.10"

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
