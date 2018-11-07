class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/2f/7e/dd1bf258ea12f28b38f7416fec75792307bb624a939e255eec261e01fa89/FoBiS.py-2.9.3.tar.gz"
  sha256 "ea3d064039fb08f690e86b66dbb12616a41304eaaf6caa2fa9f84b71bb27bdbf"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a2c2ad4f9320ea0017b34356fc36d23a2b3f87d39e5fd44e0c9918b152144d89" => :mojave
    sha256 "34f1802723d27f435fd2ed72fceb75fbda38d350efc227753d05a53f2c876b7a" => :high_sierra
    sha256 "38cda93369dddfd8f52f43271f4d0eea5b78506a4b74265a16ec5e09c60ca532" => :sierra
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python"

  resource "pygooglechart" do
    url "https://files.pythonhosted.org/packages/95/88/54f91552de1e1b0085c02b96671acfba6e351915de3a12a398533fc82e20/pygooglechart-0.4.0.tar.gz"
    sha256 "018d4dd800eea8e0e42a4b3af2a3d5d6b2a2b39e366071b7f270e9628b5f6454"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/d1/63b62dee9e55368f60b5ea445e6afb361bb47e692fc27553f3672e16efb8/graphviz-0.8.2.zip"
    sha256 "606741c028acc54b1a065b33045f8c89ee0927ea77273ec409ac988f2c3d1091"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install "pygooglechart"
    venv.pip_install "graphviz"
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
