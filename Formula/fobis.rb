class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/82/2f/68a46ea678a8396892cec7756a4c16339357726f332d9140bbc0505a7f5c/FoBiS.py-2.2.5.tar.gz"
  sha256 "3fc8c07da0acc870ef4fce7763c5f9e63a589e189923d60cae6d5affaa27cd98"

  bottle do
    cellar :any_skip_relocation
    sha256 "36c944d6623254f0befee6187a0f12b12d121c91bf7394eeadca741c2ea41398" => :sierra
    sha256 "6e78d28082cf41874949412285e73c618fd4d91aa82b0326aeb56e9e7cd8f935" => :el_capitan
    sha256 "497465ce3e15bd96c27063384317899380488a16d6f101bad80e87bac5143d22" => :yosemite
  end

  option "without-pygooglechart", "Disable support for coverage charts generated with pygooglechart"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :fortran
  depends_on "graphviz" => :recommended

  resource "pygooglechart" do
    url "https://files.pythonhosted.org/packages/95/88/54f91552de1e1b0085c02b96671acfba6e351915de3a12a398533fc82e20/pygooglechart-0.4.0.tar.gz"
    sha256 "018d4dd800eea8e0e42a4b3af2a3d5d6b2a2b39e366071b7f270e9628b5f6454"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/7d/2d/f5cfa56467ca5a65eb44e1103d89d2f65dbc4f04cf7a1f3d38e973c3d1a8/graphviz-0.7.1.zip"
    sha256 "c7744df945fa90791ad9b4183a6a7dc8220d63a7b8a5f8f93ba62086f1e69e83"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install "pygooglechart" if build.with? "pygooglechart"
    venv.pip_install "graphviz" if build.with? "graphviz"
    venv.pip_install_and_link buildpath
  end

  test do
    ENV.fortran
    (testpath/"test-mod.f90").write <<-EOS.undent
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    EOS
    (testpath/"test-prog.f90").write <<-EOS.undent
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    EOS
    system "#{bin}/FoBiS.py", "build", "-compiler", "gnu"
    assert_match /Hello FoBiS/, shell_output(testpath/"test-prog")
  end
end
