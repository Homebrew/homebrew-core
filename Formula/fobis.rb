class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/12/5f/1bef44550a3ce04062080c1fc48760672a8ecdd9a04d9da0f1a9611a6b8f/FoBiS.py-2.9.2.tar.gz"
  sha256 "465dd62e91356298c25e04f5696b0f9bddcf17111c5e49b937925a8f1563c494"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec9c59351830b3c073a8a4a736485bf54dacd008c00e31d1f3746522b7464932" => :high_sierra
    sha256 "88c07fd15dcbb0cdeaf1ca191d6230ebd2d92d5441f3e7a8d0211a70a76343ce" => :sierra
    sha256 "59c6aa0f5784eadded4ada95083489a24063917a9fc3b73c0fc9055a4f44ba3b" => :el_capitan
  end

  option "without-pygooglechart", "Disable support for coverage charts generated with pygooglechart"

  depends_on "gcc" # for gfortran
  depends_on "python@2"
  depends_on "graphviz" => :recommended

  resource "pygooglechart" do
    url "https://files.pythonhosted.org/packages/95/88/54f91552de1e1b0085c02b96671acfba6e351915de3a12a398533fc82e20/pygooglechart-0.4.0.tar.gz"
    sha256 "018d4dd800eea8e0e42a4b3af2a3d5d6b2a2b39e366071b7f270e9628b5f6454"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/d1/63b62dee9e55368f60b5ea445e6afb361bb47e692fc27553f3672e16efb8/graphviz-0.8.2.zip"
    sha256 "606741c028acc54b1a065b33045f8c89ee0927ea77273ec409ac988f2c3d1091"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install "pygooglechart" if build.with? "pygooglechart"
    venv.pip_install "graphviz" if build.with? "graphviz"
    venv.pip_install_and_link buildpath
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
    system "#{bin}/FoBiS.py", "build", "-compiler", "gnu"
    assert_match /Hello FoBiS/, shell_output(testpath/"test-prog")
  end
end
