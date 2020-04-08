class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/6e/bb/4217e14618b18427623b90fc57b50929c5c09ece31b47d4a9b5ece01ece7/FoBiS.py-3.0.2.tar.gz"
  sha256 "77cff83a6284f84f39e956ad761f9b49e8f826c71fe2230b2f8196537cdd3277"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f5841f26d4b84d2ca12274152b2c98d2e73922d806d85af64aeefc10aaf8e687" => :catalina
    sha256 "075466844a85ba69a865e143f646b0d35dcca36ee228464bba70c2ca719aea64" => :mojave
    sha256 "d34c4c5de9e019f2e37c949dbf008a1002879773fffc3649a75668046e4c7b8a" => :high_sierra
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.8"

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
    virtualenv_install_with_resources
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
