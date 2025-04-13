class Fprettify < Formula
  include Language::Python::Virtualenv

  desc "Auto-formatter for modern fortran source code"
  homepage "https://github.com/fortran-lang/fprettify/"
  url "https://github.com/fortran-lang/fprettify/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "052da19a9080a6641d3202e10572cf3d978e6bcc0e7db29c1eb8ba724e89adc7"
  license "GPL-3.0-or-later"
  head "https://github.com/fortran-lang/fprettify.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "f9d9e214fb3810e34036e058e5dd26087ff761ff4ff07d993badd0eeb2de2de5"
  end

  depends_on "gcc" => :test
  depends_on "python@3.13"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"fprettify", "--version"
    (testpath/"test.f90").write <<~FORTRAN
      program demo
      integer :: endif,if,elseif
      integer,DIMENSION(2) :: function
      endif=3;if=2
      if(endif==2)then
      endif=5
      elseif=if+4*(endif+&
      2**10)
      elseif(endif==3)then
      function(if)=elseif/endif
      print*,endif
      endif
      end program
    FORTRAN
    system bin/"fprettify", testpath/"test.f90"
    ENV.fortran
    system ENV.fc, testpath/"test.f90", "-o", testpath/"test"
    system testpath/"test"
  end
end
