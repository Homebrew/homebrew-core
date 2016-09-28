class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects."
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/e1/46/a1f93037bc1e56abf3acfadd04b8c41ba083a2a396b8a2d1113ea8382abc/FoBiS.py-2.1.0.tar.gz"
  sha256 "a95e5c960e19bf0dcdab49049c528ee7a54353408ce63a5ced03cd4e3ae42bae"

  bottle do
    cellar :any_skip_relocation
    sha256 "868e2fb8e1f9a892a5143f524243056eccd8a1d059258ba8d0a1385926ebabbc" => :el_capitan
    sha256 "f8727036ec9590ccb924f3731a2d78e93c6a15f62dfba96874e5db7e61363fc3" => :yosemite
    sha256 "927e81ec5da0cca19987e98fe069f2c03c7cf9eb3db97ca8cc5dda5e5bea995e" => :mavericks
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
    url "https://files.pythonhosted.org/packages/3a/ef/4be504e14ef8c96503aeb774937b1539aa2c6982e1edffd655ac3b7f2041/graphviz-0.5.1.zip"
    sha256 "d8f8f369a5c109d3fc971bbc1860b6848515d210aee8f5019c460351dbb00a50"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install "pygooglechart" if build.with? "pygooglechart"
    venv.pip_install "graphviz" if build.with? "graphviz"
    venv.pip_install_and_link buildpath
  end

  test do
    ENV.fortran
    (testpath/"test-mod.f90").write <<-EOS.undent
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    EOS
    (testpath/"test-prog.f90").write <<-EOS.undent
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
