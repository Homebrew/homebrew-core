class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 6

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f367b98f66b6d05ce4fcb46388c79a3cbd016840870aff8dc412e7ea4b3bb31a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0253ba558377b22aae2cf1cc774e98544be21d702989478a7704d56a96951db3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bc40072f88d065fd6588b147013018a85572795097a0fb3ca33c0941584efb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "66cfac130a30d248c233c887fae175a245c5be23357590e1aa5c74ddaf977da8"
    sha256 cellar: :any_skip_relocation, ventura:        "def7728cf1b68516eaf4ff3b42bf812d2672908eecb823465ca4e202c9fc4b49"
    sha256 cellar: :any_skip_relocation, monterey:       "aef713bc80ad4926e370adefbd3c41734def5b5b6d6c9ecb84fcca4389d7b46a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd7a5fa0e49dfa41b01e00f61d343828e9ce9a1b540ecc99a47d65d8c980930"
  end

  depends_on "python@3.12"

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
