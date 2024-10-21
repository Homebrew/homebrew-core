class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/53/3a/5533ab0277977027478b4c1285bb20b6beb221b222403b10398fb24e81a2/FoBiS.py-3.0.5.tar.gz"
  sha256 "ef23fde4199277abc693d539a81e0728571c349174da6b7476579f82482ab96c"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53df92c1b0b300b7bf005bad0a66a53de1285fe28be922e36d70876e9c123463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53df92c1b0b300b7bf005bad0a66a53de1285fe28be922e36d70876e9c123463"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53df92c1b0b300b7bf005bad0a66a53de1285fe28be922e36d70876e9c123463"
    sha256 cellar: :any_skip_relocation, sonoma:        "53df92c1b0b300b7bf005bad0a66a53de1285fe28be922e36d70876e9c123463"
    sha256 cellar: :any_skip_relocation, ventura:       "53df92c1b0b300b7bf005bad0a66a53de1285fe28be922e36d70876e9c123463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6ce8ec984624bd49fe0d7dbb0992e79342f2b1de44e9ebd306c43eb2afd0bfb"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.13"

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/a5/2e/a8d83652990ecb5df54680baa0c53d182051d9e164a25baa0582363841d1/configparser-7.1.0.tar.gz"
    sha256 "eb82646c892dbdf773dae19c633044d163c3129971ae09b49410a303b8e0a5f7"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-mod.f90").write <<~EOS
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    EOS

    (testpath/"test-prog.f90").write <<~EOS
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    EOS

    system bin/"FoBiS.py", "build", "-compiler", "gnu"
    assert_match "Hello FoBiS", shell_output(testpath/"test-prog")
  end
end
