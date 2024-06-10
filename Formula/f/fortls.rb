class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://fortls.fortran-lang.org/"
  url "https://files.pythonhosted.org/packages/38/56/38b11a3b5e3025dcb6054b16e00772b7d3d6701442fabd25722ff311996c/fortls-3.1.1.tar.gz"
  sha256 "ef248ce72bd1656d37ddb4d52f67c4764926102c749fc65b58429dcf9120e48d"
  license "MIT"
  head "https://github.com/fortran-lang/fortls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d443c225335e5ba2dbc876feb1dd42ba01a52799a8a169d1d459433020ec493"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d443c225335e5ba2dbc876feb1dd42ba01a52799a8a169d1d459433020ec493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d443c225335e5ba2dbc876feb1dd42ba01a52799a8a169d1d459433020ec493"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d443c225335e5ba2dbc876feb1dd42ba01a52799a8a169d1d459433020ec493"
    sha256 cellar: :any_skip_relocation, ventura:        "7d443c225335e5ba2dbc876feb1dd42ba01a52799a8a169d1d459433020ec493"
    sha256 cellar: :any_skip_relocation, monterey:       "7d443c225335e5ba2dbc876feb1dd42ba01a52799a8a169d1d459433020ec493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b832d03239ff371f68f0461562338ea938548b538c82da1522a414289cd5a7c5"
  end

  depends_on "python@3.12"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https://files.pythonhosted.org/packages/91/59/51b032d53212a51f17ebbcc01bd4217faab6d6c09ed0d856a987a5f42bbc/json5-0.9.25.tar.gz"
    sha256 "548e41b9be043f9426776f05df8635a00fe06104ea51ed24b67f908856e151ae"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    virtualenv_install_with_resources

    # Disable automatic update check
    (bin/"fortls").unlink
    (bin/"fortls").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/python3 -m fortls --disable_autoupdate "$@"
    EOS
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
