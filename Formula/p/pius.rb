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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e031f7d3ef469e8f1f4d99cc683122ba9b44ce3b663263ba5a7e39070e808f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e031f7d3ef469e8f1f4d99cc683122ba9b44ce3b663263ba5a7e39070e808f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e031f7d3ef469e8f1f4d99cc683122ba9b44ce3b663263ba5a7e39070e808f9"
    sha256 cellar: :any_skip_relocation, ventura:        "984bb44f8297fd26d73884d90085ae21a80e7465fa5ada5e89796f83d6dacca3"
    sha256 cellar: :any_skip_relocation, monterey:       "984bb44f8297fd26d73884d90085ae21a80e7465fa5ada5e89796f83d6dacca3"
    sha256 cellar: :any_skip_relocation, big_sur:        "984bb44f8297fd26d73884d90085ae21a80e7465fa5ada5e89796f83d6dacca3"
    sha256 cellar: :any_skip_relocation, catalina:       "984bb44f8297fd26d73884d90085ae21a80e7465fa5ada5e89796f83d6dacca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98a475c26c715d2eb8476151aee91992fe48f8e1bc286062f797bcaf8297cb85"
  end

  depends_on "gnupg"
  depends_on "python@3.11"

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
