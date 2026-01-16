class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://fortls.fortran-lang.org/"
  url "https://files.pythonhosted.org/packages/c1/2b/db1e5cd07fc9e74a2e4fb8f65946f8fd79ef72211001af00982a04d977d5/fortls-3.2.2.tar.gz"
  sha256 "b43b2b8cbd447ae848c63b8f008c2df96fd48c3a967b33f6ed64b3421496883b"
  license "MIT"
  head "https://github.com/fortran-lang/fortls.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "833467280f06afa96acd625eef628c7013b9cab7f781a06748336fbc34539d91"
  end

  depends_on "python@3.14"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https://files.pythonhosted.org/packages/12/ae/929aee9619e9eba9015207a9d2c1c54db18311da7eb4dcf6d41ad6f0eb67/json5-0.12.1.tar.gz"
    sha256 "b2743e77b3242f8d03c143dd975a6ec7c52e2f2afe76ed934e53503dd4ad4990"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
    (testpath/"test.f90").write <<~FORTRAN
      program main
      end program main
    FORTRAN
    system bin/"fortls", "--debug_filepath", testpath/"test.f90", "--debug_symbols", "--debug_full_result"
  end
end
