class Fprettify < Formula
  include Language::Python::Virtualenv

  desc "Auto-formatter for modern fortran source code"
  homepage "https://github.com/fortran-lang/fprettify/"
  url "https://files.pythonhosted.org/packages/39/15/d88681bd2be4a375a78b52443b8e87608240913623d9be5c47e3c328b068/fprettify-0.3.7.tar.gz"
  sha256 "1488a813f7e60a9e86c56fd0b82bd9df1b75bfb4bf2ee8e433c12f63b7e54057"
  license "GPL-3.0-or-later"
  head "https://github.com/fortran-lang/fprettify.git", branch: "master"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "2eed8e7434178165e755f3a4862a8b79e045d89b08754c9e7abccfd918b4c5b1"
  end

  depends_on "gcc" => :test
  depends_on "python@3.15"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/5d/ed/33c0ba7f0b5be384ff8a2101ce77728f219e816b2104819f1651477e1ad5/configargparse-1.8.0.tar.gz"
    sha256 "22a417f4d7b00149f0af82ef7c491f8ecc4b1d5454633fd319b386f5eb806f92"
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
