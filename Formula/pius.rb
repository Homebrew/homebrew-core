class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v3.0.0.tar.gz"
  sha256 "3454ade5540687caf6d8b271dd18eb773a57ab4f5503fc71b4769cc3c5f2b572"
  license "GPL-2.0"
  revision 2
  head "https://github.com/jaymzh/pius.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30e6a2eac50a9ac4090606b89ac29de3363d8c294d62fbf54a1c0a7db07c02be"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a5deabe6e56424603556f18ccee09a5d2e71f63cbb5a7963faf541556de0f87"
    sha256 cellar: :any_skip_relocation, catalina:      "ef07a9e877e3774888c7e27378362744448590daee47bba22ab463f4a90660be"
    sha256 cellar: :any_skip_relocation, mojave:        "3cfa04458840eab00f16c10a34dceb55783dd9d52178fab890d32e70fab5ee1f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "fbbecdabd75369b65e0c00c3b2ccdb91f34c643e73a3c81eaa4bc6474f5783e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "653d812e19ae81de3efd315d398820eccc1c848e030b584c4570154c9f8721f5"
  end

  depends_on "gnupg"
  depends_on "python@3.9"

  def install
    # Replace hardcoded gpg path (WONTFIX)
    inreplace "libpius/constants.py", %r{/usr/bin/gpg2?}, "/usr/bin/env gpg"
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      The path to gpg is hardcoded in pius as `/usr/bin/env gpg`.
      You can specify a different path by editing ~/.pius:
        gpg-path=/path/to/gpg
    EOS
  end

  test do
    system bin/"pius", "-T"
  end
end
