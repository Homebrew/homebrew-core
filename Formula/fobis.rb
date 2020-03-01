class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/6e/bb/4217e14618b18427623b90fc57b50929c5c09ece31b47d4a9b5ece01ece7/FoBiS.py-3.0.2.tar.gz"
  sha256 "77cff83a6284f84f39e956ad761f9b49e8f826c71fe2230b2f8196537cdd3277"

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

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "pygooglechart" do
    url "https://files.pythonhosted.org/packages/95/88/54f91552de1e1b0085c02b96671acfba6e351915de3a12a398533fc82e20/pygooglechart-0.4.0.tar.gz"
    sha256 "018d4dd800eea8e0e42a4b3af2a3d5d6b2a2b39e366071b7f270e9628b5f6454"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/5d/71/f63fe59145fca7667d92475f1574dd583ad1f48ab228e9a5dddd5733197f/graphviz-0.13.2.zip"
    sha256 "60acbeee346e8c14555821eab57dbf68a169e6c10bce40e83c1bf44f63a62a01"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
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
