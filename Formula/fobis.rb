class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/39/35/666a8af46051e5e12cd84d677acda478687d348453b0b9a368332705f687/FoBiS.py-2.2.3.tar.gz"
  sha256 "d26348f24e613db6d8570438a38276b2aff3b2a84d17104a0fdd0a78601f877f"

  bottle do
    cellar :any_skip_relocation
    sha256 "46e449b0ac1eeae10a05d4021bdfe98226ce1d4eff51fe6c410a8e22efc72746" => :sierra
    sha256 "c207fc4e30f2d0dbaf1b8b3015012d0490f1e00762a1868147476516cad46875" => :el_capitan
    sha256 "2213f68df5dc52a2a0d6dca26b4bac1b6391c0bdaf364780ff3d04872e4edc5a" => :yosemite
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
