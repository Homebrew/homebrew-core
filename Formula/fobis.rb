class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/7a/49/9ccbc08da74f0c37901b07e00aa8e6419895c45723b80119994d89a72eec/FoBiS.py-2.9.5.tar.gz"
  sha256 "0f27bad2c662d2df666ede8bfdd9b1f3fb41e293cb7008da388c52efef060335"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f107ff8d6beb4cf7ab0a3cc58a6547537e2ed9ec4eb4ceea8f671539e3fbdf3" => :catalina
    sha256 "7bbf823ceabbd79717f3fe748771f64c6a81f6f9f3a3fbacfa5febad8374011a" => :mojave
    sha256 "6ea243c05063c86081b365812f719943838497f666849590276554ea2039fb31" => :high_sierra
    sha256 "5e40a0c3bef0e4ae83cbb4eb25f72aa0d98a6e54a5515897ca82ad25fd055892" => :sierra
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
