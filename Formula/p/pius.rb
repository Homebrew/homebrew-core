class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3454ade5540687caf6d8b271dd18eb773a57ab4f5503fc71b4769cc3c5f2b572"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/jaymzh/pius.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "862a5a7ce264a77363a1a3e1a48ee177a712579e68aa469b96f714ebb5a81043"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "862a5a7ce264a77363a1a3e1a48ee177a712579e68aa469b96f714ebb5a81043"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "862a5a7ce264a77363a1a3e1a48ee177a712579e68aa469b96f714ebb5a81043"
    sha256 cellar: :any_skip_relocation, sonoma:         "862a5a7ce264a77363a1a3e1a48ee177a712579e68aa469b96f714ebb5a81043"
    sha256 cellar: :any_skip_relocation, ventura:        "862a5a7ce264a77363a1a3e1a48ee177a712579e68aa469b96f714ebb5a81043"
    sha256 cellar: :any_skip_relocation, monterey:       "862a5a7ce264a77363a1a3e1a48ee177a712579e68aa469b96f714ebb5a81043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e8b7405f3fb6071e55b19cbb78beaf73289719a67aebeead7f317080db78a9"
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
    output = shell_output("#{bin}/pius -T")
    assert_match "Welcome to PIUS, the PGP Individual UID Signer", output

    assert_match version.to_s, shell_output("#{bin}/pius --version")
  end
end
