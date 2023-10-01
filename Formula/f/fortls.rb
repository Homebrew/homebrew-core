class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://fortls.fortran-lang.org/"
  url "https://files.pythonhosted.org/packages/38/04/db988efbcaac142999af91888e9750dfa422108a318ec3038c2cd42ecf04/fortls-2.13.0.tar.gz"
  sha256 "23c5013e8dd8e1d65bf07be610d0827bc48aa7331a7a7ce13612d4c646d0db31"
  license "MIT"
  head "https://github.com/fortran-lang/fortls.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5084af342b76751abfb89ccf94cc02e9c933ad2255b726c2684723cab71baa66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f98955f773c5ef23b33ce6594b77d2fda676d2ea0789fb15d81f9a40921a74f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1b913720062c466bf1bf3fdbd7c3c2740b3fb2a601614a42ac616653738e781"
    sha256 cellar: :any_skip_relocation, ventura:        "39bdc99826e7b98a9aff6e3bec0890ffce6193c52c25e0241ad8eb6b6ac3134c"
    sha256 cellar: :any_skip_relocation, monterey:       "b264dc16ce0c546bdf2bb88ee9d97257540fc67900496534055e1c7ac721197f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee205e3032f671e4f1a74537babce6b5a601ed200409f4a06e8a33b0b31733b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6831e98c5178e25885d10ff6bbc0c81a60cdf6463b409519a8e0b3fb3d38efb3"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https://files.pythonhosted.org/packages/47/12/611bf15000c1fc54af909565aed1ad045e5ae1890d8c56cbfe5ceaf52446/json5-0.9.10.tar.gz"
    sha256 "ad9f048c5b5a4c3802524474ce40a622fae789860a86f10cc4f7e5f9cf9b46ab"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    virtualenv_install_with_resources

    # Disable automatic update check
    (bin/"fortls").unlink
    # Replace with `exec python3 -m fortls --disable_autoupdate "$@"` in the future
    (bin/"fortls").write <<~EOS
      #!#{libexec}/bin/python3

      import re
      import sys

      from fortls.__init__ import main

      if __name__ == '__main__':
          sys.argv[0] = re.sub(r'(-script.pyw?|.exe)?$', '', sys.argv[0])
          sys.argv.append('--disable_autoupdate')
          sys.exit(main())
    EOS
    chmod 0755, "#{bin}/fortls"
  end

  test do
    system bin/"fortls", "--help"
    (testpath/"test.f90").write <<~EOS
      program main
      end program main
    EOS
    system bin/"fortls", "--debug_filepath", testpath/"test.f90", "--debug_symbols", "--debug_full_result"
  end
end
