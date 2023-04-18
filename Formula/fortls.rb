class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://gnikit.github.io/fortls"
  url "https://files.pythonhosted.org/packages/38/04/db988efbcaac142999af91888e9750dfa422108a318ec3038c2cd42ecf04/fortls-2.13.0.tar.gz"
  sha256 "23c5013e8dd8e1d65bf07be610d0827bc48aa7331a7a7ce13612d4c646d0db31"
  license "MIT"
  head "https://github.com/gnikit/fortls.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d343091984013ed0eb45865981423c44f0c01e794d415cba0910bb9ac4241d83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "174b1f4e2cd7d06a56dd4c8883d136a420ce74d57310c07f7e5aa2f095f68f71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cb162dde0328f45c09e9d0e184d6796183551df29380a8fde13cc97ed1309c5"
    sha256 cellar: :any_skip_relocation, ventura:        "4e6939a128ef37a6426147a959f339373998e400a50f8d4b2f7056b71ea25f26"
    sha256 cellar: :any_skip_relocation, monterey:       "4f88081d545cecc1965e05ec0691192b878461e30225cdcc24e0025b0fcd5941"
    sha256 cellar: :any_skip_relocation, big_sur:        "305bc04b30d95ef280fc34d1fea38f032e54a19a126d016da69835a35877ee8e"
    sha256 cellar: :any_skip_relocation, catalina:       "853915ba370ec51c3c2ed3aa8253f31691a9a4674e3708f4c22084b2b4420994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba1a8b8188320fa146ab8ae10b970a539e8514ca07daa43a427479447bd204c"
  end

  depends_on "python@3.11"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https://files.pythonhosted.org/packages/47/12/611bf15000c1fc54af909565aed1ad045e5ae1890d8c56cbfe5ceaf52446/json5-0.9.10.tar.gz"
    sha256 "ad9f048c5b5a4c3802524474ce40a622fae789860a86f10cc4f7e5f9cf9b46ab"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
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
