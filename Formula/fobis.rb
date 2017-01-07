class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/54/8e/aa0421da748d5338a2b7fd03919ff31ad3be683975893da610282260a935/FoBiS.py-2.2.2.tar.gz"
  sha256 "a3f28cf8504f9d44cca13a8d367afb8426bca5c90d98533363361ff7fa97c6d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce0880480a3f04767e96b078019c447497b7091471e24e02485c870ee61288e6" => :sierra
    sha256 "064fd4d11c051573402e9bc309952dc2fa5b89b42aef7185658bafd46b66a2aa" => :el_capitan
    sha256 "342731cf6aa3d5d7a8ba227dfbc99c45b7e6ce1d6856f83928b9fdee3dc4ad13" => :yosemite
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
    url "https://files.pythonhosted.org/packages/01/98/8dec899491e4ac01a6fc8269e3b6dffd35421321b6858e21672489678fa8/graphviz-0.5.2.zip"
    sha256 "60ea67b383e3feb71fd0cb3137c02f8c4a76935996cf06a9e77d6150a90d034a"
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
