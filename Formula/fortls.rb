class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://gnikit.github.io/fortls"
  url "https://pypi.io/packages/source/f/fortls/fortls-2.13.0.tar.gz"
  sha256 "23c5013e8dd8e1d65bf07be610d0827bc48aa7331a7a7ce13612d4c646d0db31"
  license "MIT"
  head "https://github.com/gnikit/fortls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2d6013ad6fdae9855ecf1cc095712a02277d4f13a708346b68d6db455b4bd78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6701692537a0730c2ac2a2723edc9133474dacf3af4bc7f45a06325b01c5831e"
    sha256 cellar: :any_skip_relocation, monterey:       "14df9f15ec27ddd1c7f1dfec19661d9f34d4e46d75895fac5298914779184f55"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fa0491997b42f3ab7e8e8a8c2d7417efe708652a46b8599ccb4e291e080adb0"
    sha256 cellar: :any_skip_relocation, catalina:       "53dd5cbaa4945e26e86b1dcb09ffda3f2f199638ab9fe1dceea3f417a5af3fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d83b540e20a624338af94720bd2322daa2bc5443923f9fe8f7ca6b0441a41ccb"
  end

  depends_on "python@3.10"

  resource "json5" do
    url "https://pypi.io/packages/source/j/json5/json5-0.9.5.tar.gz"
    sha256 "703cfee540790576b56a92e1c6aaa6c4b0d98971dc358ead83812aa4d06bdb96"
  end

  resource "packaging" do
    url "https://pypi.io/packages/source/p/packaging/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://pypi.io/packages/source/p/pyparsing/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    virtualenv_install_with_resources

    # Disable automatic update check
    rm bin/"fortls"
    # Replace with `exec python3 -m fortls --disable_autoupdate "$@"` in the future
    (bin/"fortls").write <<~EOS
      #!#{libexec}/bin/python3

      import re
      import sys

      from fortls.__init__ import main

      if __name__ == '__main__':
          sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
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
