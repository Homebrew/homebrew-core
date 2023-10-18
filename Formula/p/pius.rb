class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v3.0.0.tar.gz"
  sha256 "3454ade5540687caf6d8b271dd18eb773a57ab4f5503fc71b4769cc3c5f2b572"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/jaymzh/pius.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7db22333dff6771f81743380020357448e6636f1883f524e28b70a169d83f2b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f6ad056df2d84dc9bb16aeceabb5bb5c3bfeaffe7f0f8b569b1d9da78b79f9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15eedda033269333588112de00e19fdc24146d741e5856bd3605f1c058be9c2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "38bf618af0df7d245eabf6d7fff12b399c22cdb678f24fa0d98d3b530683bc71"
    sha256 cellar: :any_skip_relocation, ventura:        "31ccbff40673fd6f4dbce641f7eda3a2b534666f76d55a02bc67f6ed0dc8ef74"
    sha256 cellar: :any_skip_relocation, monterey:       "9702a21095214752a4f4541f8dc19a97204d812c5f223ea645fa42c7ae4efb32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0a5c15872c6e24e56cc856c25c78ac7c89a7845afe7abd8513db31192d3d97"
  end

  depends_on "gnupg"
  depends_on "python@3.12"

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
