class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/6e/c3/217ba20c53a39e68f7bef139a47f5c820230d1d672529de44c9bd961a023/FoBiS.py-2.2.7.tar.gz"
  sha256 "ed5054fc3887159ae7cafa32f16859761216ab678390ccc328b624ac5e960c63"

  bottle do
    cellar :any_skip_relocation
    sha256 "c712bc45ba7f821ab648adef31a172a70fc636e3008da53a244a92c9568467a5" => :high_sierra
    sha256 "a442b70f322b7a21aa3c80fe501a0ad9d72b441f4265ad66322a1e2182a609d9" => :sierra
    sha256 "e61dd9c83fa76a888fb484442875cb2c919a1662d73e8752a7517f68feba64eb" => :el_capitan
    sha256 "549280c74f577a2aedd2627b7b4d082645ce3aa368d52f35b3c48f0e666b8413" => :yosemite
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
    system "#{bin}/FoBiS.py", "build", "-compiler", "gnu"
    assert_match /Hello FoBiS/, shell_output(testpath/"test-prog")
  end
end
