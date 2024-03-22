class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://fortls.fortran-lang.org/"
  url "https://files.pythonhosted.org/packages/38/04/db988efbcaac142999af91888e9750dfa422108a318ec3038c2cd42ecf04/fortls-2.13.0.tar.gz"
  sha256 "23c5013e8dd8e1d65bf07be610d0827bc48aa7331a7a7ce13612d4c646d0db31"
  license "MIT"
  head "https://github.com/fortran-lang/fortls.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f72f3698e59bbac8d6f18cc0837a069f780677fb2eba3b4ad1a7c54159c9a511"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7251adffa56e231b0fd92d1b1bb862dd60d8d0453757e4e8956a97e2e949238a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e3d8d40a2958cdac989492c3c547074c1e1a4aeecfef2b4b8a645f5c6cab97c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1e3429b82468af4bc8df61ca17d26184aeeabdea52dd24cccae1149739b2116"
    sha256 cellar: :any_skip_relocation, ventura:        "297dbb38409899d4641895bc9ea234813ee91ed00340a333d2d0063afb37d259"
    sha256 cellar: :any_skip_relocation, monterey:       "d20219ad11612fd7339f2c292dfa2dd62a9f264be2f2c5bdd9f65d951c9c6d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec87f2bc7d3c8013ca32e1bc113d6c9d82a4080bd6bb1de170d1ab9c59ce7fa"
  end

  depends_on "python@3.12"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https://files.pythonhosted.org/packages/f9/40/89e0ecbf8180e112f22046553b50a99fdbb9e8b7c49d547cda2bfa81097b/json5-0.9.14.tar.gz"
    sha256 "9ed66c3a6ca3510a976a9ef9b8c0787de24802724ab1860bc0153c7fdd589b02"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
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
