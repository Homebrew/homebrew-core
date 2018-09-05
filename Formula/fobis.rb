class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/2f/7e/dd1bf258ea12f28b38f7416fec75792307bb624a939e255eec261e01fa89/FoBiS.py-2.9.3.tar.gz"
  sha256 "ea3d064039fb08f690e86b66dbb12616a41304eaaf6caa2fa9f84b71bb27bdbf"

  bottle do
    cellar :any_skip_relocation
    sha256 "c99de2a4f32e73f815fabd7732692617fe502f5147422a8bf4d1e292829ccacc" => :mojave
    sha256 "e0b6839e9335bdc48820c8e789dc2adaa8700cc307f2c52c2d476beb4257f547" => :high_sierra
    sha256 "0807879b1f5695795660ee05979727c38b6992e77214b3fcca5eeba52203b303" => :sierra
    sha256 "9be1a5d77e8c9d546b2eb129b4ecf607fd501eb1ad2e025276261c4144d0bf02" => :el_capitan
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
