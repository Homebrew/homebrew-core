class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/ac/b8/fd3b12a7d9c2c6d9ff424c90f3dcab9b4dae6087c749cbfb26d53b49e623/FoBiS.py-2.2.6.tar.gz"
  sha256 "323e3fcca796c0360467c7384c7a16976ccad2238318fb100b9f794c7aab8fb1"

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
    url "https://files.pythonhosted.org/packages/da/84/0e997520323d6b01124eb01c68d5c101814d0aab53083cd62bd75a90f70b/graphviz-0.8.zip"
    sha256 "889c720d9955b804d56a8e842621558cbb5cbbdd93cbdf55862371311646e344"
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
