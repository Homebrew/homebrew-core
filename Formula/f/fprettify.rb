class Fprettify < Formula
  include Language::Python::Virtualenv

  desc "Auto-formatter for modern fortran source code"
  homepage "https://github.com/fortran-lang/fprettify/"
  url "https://files.pythonhosted.org/packages/39/15/d88681bd2be4a375a78b52443b8e87608240913623d9be5c47e3c328b068/fprettify-0.3.7.tar.gz"
  sha256 "1488a813f7e60a9e86c56fd0b82bd9df1b75bfb4bf2ee8e433c12f63b7e54057"
  license "GPL-3.0-or-later"
  head "https://github.com/fortran-lang/fprettify.git", branch: "master"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, all: "fdd5b8e9dc7618159259e688b329a44ea1c6f5be9bc615f98d6c29128e07dd2d"
  end

  depends_on "gcc" => :test
  depends_on "python@3.14"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
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
