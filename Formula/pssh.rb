class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55cce3be0cd183f6179aeb4b51618774fe98cb3e4df078d1fff9ee3e555d2a54"
    sha256 cellar: :any_skip_relocation, big_sur:       "94ad17e8296472da13da212b912f9edd9fd849566a21eee7b3ad7686f4500e0b"
    sha256 cellar: :any_skip_relocation, catalina:      "94ad17e8296472da13da212b912f9edd9fd849566a21eee7b3ad7686f4500e0b"
    sha256 cellar: :any_skip_relocation, mojave:        "94ad17e8296472da13da212b912f9edd9fd849566a21eee7b3ad7686f4500e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe66dd066755c80bec5fee0da2348519605663f4d1a2ecd1c52b164e30b4519"
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
