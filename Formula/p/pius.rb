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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d61505ec3e8d340eb73ba9aaa4a2660e1ffb625a0025b1898b4bde9229450b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79b3b946b30313322876f8c7162665452b36016cb4104bbd61c2a34625ea7305"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de8e42fd48ced2f779174d71a2560d7bab6f1125cec510fb06ab0e93476a4e43"
    sha256 cellar: :any_skip_relocation, sonoma:         "c51ae66b1d1198fc3e3822da507bdde8687a1a055ee6b11c951a6e327312e661"
    sha256 cellar: :any_skip_relocation, ventura:        "dd3fea786b40a2887356e3eab80b2456a2bad6e1507679a2973012ec3b057100"
    sha256 cellar: :any_skip_relocation, monterey:       "72db7c293352ab01e5c8b6f4b2e9abece03f16e1a659d6679fa0ac4f40746999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09737ff9917901073a9097aba3a656ac6421ccc62acd25308a41e1bd3a45c83d"
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
