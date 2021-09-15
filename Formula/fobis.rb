class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/53/3a/5533ab0277977027478b4c1285bb20b6beb221b222403b10398fb24e81a2/FoBiS.py-3.0.5.tar.gz"
  sha256 "ef23fde4199277abc693d539a81e0728571c349174da6b7476579f82482ab96c"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfa1e5a5e7276be1292321294c418e9f1bac7a964f46d227a2d81fc3ad1b984e"
    sha256 cellar: :any_skip_relocation, big_sur:       "627133905b51d5436b9eb6a8e75080d847a6ea7c36886aa7f81e053fd89970d3"
    sha256 cellar: :any_skip_relocation, catalina:      "0a1685a770c843092bdcd918de2439bc9ed16e75b49e61e93148386b42d326d1"
    sha256 cellar: :any_skip_relocation, mojave:        "6b517fdd37dbbdfce2e3ca628afd4f92ef688c18939e78c2b0487dbc1ac7da5e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "81a5206bdd09bf9b630a9ef4793015283891d88b1790dc8638e759679d892522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e2e24bb2e1d5234fe148102d25b910e1a303d3ac9a71fa684ca9c993506b0d"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.9"

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/e5/7c/d4ccbcde76b4eea8cbd73b67b88c72578e8b4944d1270021596e80b13deb/configparser-5.0.0.tar.gz"
    sha256 "2ca44140ee259b5e3d8aaf47c79c36a7ab0d5e94d70bd4105c03ede7a20ea5a1"
  end

  resource "FoBiS.py" do
    url "https://files.pythonhosted.org/packages/53/3a/5533ab0277977027478b4c1285bb20b6beb221b222403b10398fb24e81a2/FoBiS.py-3.0.5.tar.gz"
    sha256 "ef23fde4199277abc693d539a81e0728571c349174da6b7476579f82482ab96c"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  def install
    virtualenv_install_with_resources
    bin.install libexec/"bin/FoBiS.py"
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
    assert_match "Hello FoBiS", shell_output(testpath/"test-prog")
  end
end
