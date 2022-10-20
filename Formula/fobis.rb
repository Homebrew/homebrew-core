class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/53/3a/5533ab0277977027478b4c1285bb20b6beb221b222403b10398fb24e81a2/FoBiS.py-3.0.5.tar.gz"
  sha256 "ef23fde4199277abc693d539a81e0728571c349174da6b7476579f82482ab96c"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "548370e4f657940d745a496643d34dff59954c4ec0e21c50d08ed90954d4703d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2296b45992dee7b95457824f98a16a949e6edae62dca8ce0af0859930ed8a857"
    sha256 cellar: :any_skip_relocation, monterey:       "d111f4277a23d35db7520abbcf3dc72051a0b2e995cc98ed11c8469292feb943"
    sha256 cellar: :any_skip_relocation, big_sur:        "61d0869b525dd5d508f41a55cb63906fbfdec8109c76f54426b1ab500d80fdf4"
    sha256 cellar: :any_skip_relocation, catalina:       "50ca49669814c6994889fad6f7c0ecb5087e38c6c9dc071b323aed4144ede41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d032e035815fa280f9759ffef0da5a88e787062c06fcc47dce544dcdfcc6297"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.10"

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
