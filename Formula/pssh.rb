class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "59a80ba06f64db6ac564b05a91b33cd9dab0d7d9c1a9cd7e932b9afb2b2012c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1c1837c888b3c60e7e5cf3db91660c35b14c39e72d7418317eba99fe30bee0c"
    sha256 cellar: :any_skip_relocation, catalina:      "d1c1837c888b3c60e7e5cf3db91660c35b14c39e72d7418317eba99fe30bee0c"
    sha256 cellar: :any_skip_relocation, mojave:        "d1c1837c888b3c60e7e5cf3db91660c35b14c39e72d7418317eba99fe30bee0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db241389e508b5db1cf14b6edf01b09b185f95326b8301ba7c04ee38478f7e39"
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
  end

  test do
    system bin/"pssh", "--version"
  end
end
