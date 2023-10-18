class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://fortls.fortran-lang.org/"
  url "https://files.pythonhosted.org/packages/38/04/db988efbcaac142999af91888e9750dfa422108a318ec3038c2cd42ecf04/fortls-2.13.0.tar.gz"
  sha256 "23c5013e8dd8e1d65bf07be610d0827bc48aa7331a7a7ce13612d4c646d0db31"
  license "MIT"
  head "https://github.com/fortran-lang/fortls.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d2540cdbaea952f38aac873dd8d19c9404f90093f250be08c4051a226c6397c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "364872120beea98946dd8bd10f974addc00d35617e88fca6373116ff1217237d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89708fedc19ade3e41704eab5d9dffa22867a77d3ca502c7043b1d0926572408"
    sha256 cellar: :any_skip_relocation, sonoma:         "b95eebf3293522341599f7cd32efcde0e76b43eb0c4f0148a4be0006d17055b6"
    sha256 cellar: :any_skip_relocation, ventura:        "59537d4418469e3e97545944b197142e85f780b93ec2e01db1a1e3401a6d7c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "ec86fe9071e7375e380ff118d8a9cbdf924a3c3d4dec6adf29978abf36791a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc750c090055052b2ddc422030bf75e7d56aeee7a88dadde6455b0d665fe7faf"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https://files.pythonhosted.org/packages/f9/40/89e0ecbf8180e112f22046553b50a99fdbb9e8b7c49d547cda2bfa81097b/json5-0.9.14.tar.gz"
    sha256 "9ed66c3a6ca3510a976a9ef9b8c0787de24802724ab1860bc0153c7fdd589b02"
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
