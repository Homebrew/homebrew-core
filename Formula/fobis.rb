class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/53/3a/5533ab0277977027478b4c1285bb20b6beb221b222403b10398fb24e81a2/FoBiS.py-3.0.5.tar.gz"
  sha256 "ef23fde4199277abc693d539a81e0728571c349174da6b7476579f82482ab96c"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7363945213c145a1fccd7ceb02d78df2b605d311fd5c1e392dc799b7aed2f500"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "774c135cce4ef5e397309b159d5c3b5b2e21952a3cfcba8bb3f5dd6f034bc3c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "854eb9629c3ca906bb2d6de13e076eb6a2bd188139020ac3fc5a2cd49d7dd451"
    sha256 cellar: :any_skip_relocation, ventura:        "250b4c62f860222591fcf450c6a02d5cb6e9aa808a59f3ddcfd6fb234a3528ff"
    sha256 cellar: :any_skip_relocation, monterey:       "731d4ce8d491658b88bb87f2766c75dec55b159cdac441bcf5457ed7d79b99b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9033858010025b95f32fb53879df00590f01cde953818426b6cbf38b90b944a6"
    sha256 cellar: :any_skip_relocation, catalina:       "e1640f90d8c6f8e550fec00ca990576c16a2c53ec8bf01ef46d40aff3b32c09f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9a582cec179b65493bf663b98006561268e17e30acd8ac400068fc76e191d3"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.11"

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/4b/c0/3a47084aca7a940ed1334f89ed2e67bcb42168c4f40c486e267fe71e7aa0/configparser-5.3.0.tar.gz"
    sha256 "8be267824b541c09b08db124917f48ab525a6c3e837011f3130781a224c57090"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
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
    assert_match "Hello FoBiS", shell_output(testpath/"test-prog")
  end
end
