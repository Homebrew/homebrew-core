class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://fortls.fortran-lang.org/"
  url "https://files.pythonhosted.org/packages/c1/2b/db1e5cd07fc9e74a2e4fb8f65946f8fd79ef72211001af00982a04d977d5/fortls-3.2.2.tar.gz"
  sha256 "b43b2b8cbd447ae848c63b8f008c2df96fd48c3a967b33f6ed64b3421496883b"
  license "MIT"
  head "https://github.com/fortran-lang/fortls.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "7fb66a8d3dc572a469a32db0a1d2c1d2ff2d5590abe5b5af954ef05529e7051a"
  end

  depends_on "python@3.15"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https://files.pythonhosted.org/packages/80/63/503651a3946bfacb6d6098985f2af6b3bf880d8eedc53035761c628d13bc/json5-0.16.0.tar.gz"
    sha256 "8b135a77b231f22e3656c601fec7621c5354c64c4fb2773715ee0814e4dc6bf7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  def install
    virtualenv_install_with_resources

    # Disable automatic update check
    (bin/"fortls").unlink
    (bin/"fortls").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/python3 -m fortls --disable_autoupdate "$@"
    SH
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
