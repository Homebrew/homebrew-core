class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/e8/ac/9f4bb1e9a960c52471f3453f93c2495a4594fdf09edf53a312b387593305/FoBiS.py-2.2.0.tar.gz"
  sha256 "bfb592abccc92015153bdef552c3fd82bc541b094b233923c89f35ef86dba1b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "aebecf7fcfd2111adf871b8eb996b146559e75fbe6aecebba11d992adccd60d1" => :sierra
    sha256 "64e5755b49db27325a95808a7cc8a28ac1ed4e3c4002385ac805e7d1004a56d8" => :el_capitan
    sha256 "451468120f0cc001d14768e03730a443879b9911b2b1efcc1e7ba2ca6faa9717" => :yosemite
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
