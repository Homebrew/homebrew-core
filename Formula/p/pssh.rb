class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 6

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5930def7b287c71f933a5f8cf985135891a2a9e3ca750be4a0960aa5768bdaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5930def7b287c71f933a5f8cf985135891a2a9e3ca750be4a0960aa5768bdaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5930def7b287c71f933a5f8cf985135891a2a9e3ca750be4a0960aa5768bdaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "639890de52266e0f738b67ad06579d7783b161c4e68c4b0caba5d8bd10edfd55"
    sha256 cellar: :any_skip_relocation, ventura:       "639890de52266e0f738b67ad06579d7783b161c4e68c4b0caba5d8bd10edfd55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f1da5f3faf6c95f6892a087b50fc1bc97f229ce25c68604a6a5dc7a294441b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5930def7b287c71f933a5f8cf985135891a2a9e3ca750be4a0960aa5768bdaf"
  end

  depends_on "python@3.13"

  conflicts_with "putty", because: "both install `pscp` binaries"

  # Fix for Python 3 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/957fd102811ab8a8c34bf09916a767e71dc6fd66/pssh/python3.patch"
    sha256 "aba524c201cdc1be79ecd1896d2b04b758f173cdebd53acf606c32321a7e8c33"
  end

  def install
    # fix man folder location issue
    inreplace "setup.py", "'man/man1'", "'share/man/man1'"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pssh", "--version"
  end
end
