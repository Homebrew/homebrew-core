class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/53/3a/5533ab0277977027478b4c1285bb20b6beb221b222403b10398fb24e81a2/FoBiS.py-3.0.5.tar.gz"
  sha256 "ef23fde4199277abc693d539a81e0728571c349174da6b7476579f82482ab96c"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f207c61f2ce77fc893cdd2977e12643ddadea1a4d60df31d019dfda5599096be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "147212cd6a9f780dbada04421a8fbf84e68b48a010b67a40db34b8f5ade5e771"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26c58909011ac4d947e902e1128ed5bcbf2c8847d90b00cb7d9ed43ecd0a33bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deb8ce8e0404339cb83dcc86b9e7a877e57a1d7ecf8813841ddfe076f095c2ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "117442d15b852a02ffd674c2a0644a110dea8a39308f8a64b9427fc029385a76"
    sha256 cellar: :any_skip_relocation, ventura:        "5689771979471f64086c656e092dce45e26311836a9a6932723d208b70f80c20"
    sha256 cellar: :any_skip_relocation, monterey:       "47191b5e509953a6b701c57810b7f93bc855ed515c047d8d27a0e556a7dd0c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48182e9f5852fac9b862d87d2c10efeb1bbd0d384ffdfbaf7626918a6ea3746a"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.12"

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/0b/65/bad3eb64f30657ee9fa2e00e80b3ad42037db5eb534fadd15a94a11fe979/configparser-6.0.0.tar.gz"
    sha256 "ec914ab1e56c672de1f5c3483964e68f71b34e457904b7b76e06b922aec067a8"
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
