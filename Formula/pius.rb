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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e0124059b6b127d2b562f64beacff812f23d2736d0d839472b4db761b1f2032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e0124059b6b127d2b562f64beacff812f23d2736d0d839472b4db761b1f2032"
    sha256 cellar: :any_skip_relocation, monterey:       "d456a15477875e8973b2964c50a0e2a6ce032331d92ae4b8ffee13e74324ab00"
    sha256 cellar: :any_skip_relocation, big_sur:        "d456a15477875e8973b2964c50a0e2a6ce032331d92ae4b8ffee13e74324ab00"
    sha256 cellar: :any_skip_relocation, catalina:       "d456a15477875e8973b2964c50a0e2a6ce032331d92ae4b8ffee13e74324ab00"
    sha256 cellar: :any_skip_relocation, mojave:         "d456a15477875e8973b2964c50a0e2a6ce032331d92ae4b8ffee13e74324ab00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557100f55d582878fee70866fdf4de2f17b8aba238ab261fc4c622426ae166c9"
  end

  depends_on "gnupg"
  depends_on "python@3.10"

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
