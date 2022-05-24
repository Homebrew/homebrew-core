class Fprettify < Formula
  include Language::Python::Virtualenv

  desc "Auto-formatter for modern fortran source code"
  homepage "https://github.com/pseewald/fprettify/"
  url "https://github.com/pseewald/fprettify/archive/v0.3.7.tar.gz"
  sha256 "052da19a9080a6641d3202e10572cf3d978e6bcc0e7db29c1eb8ba724e89adc7"
  license "GPL-3.0-or-later"
  head "https://github.com/pseewald/fprettify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdb3c1fb8f56f2d0a69cd8c64863e10bd4bcab09fae883f745fc28103e20a5ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdb3c1fb8f56f2d0a69cd8c64863e10bd4bcab09fae883f745fc28103e20a5ae"
    sha256 cellar: :any_skip_relocation, monterey:       "003792c125ef0380752d9dde144930d696a8dada1a1c3edce864e2417dfae574"
    sha256 cellar: :any_skip_relocation, big_sur:        "003792c125ef0380752d9dde144930d696a8dada1a1c3edce864e2417dfae574"
    sha256 cellar: :any_skip_relocation, catalina:       "003792c125ef0380752d9dde144930d696a8dada1a1c3edce864e2417dfae574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f95be72c72df4071f4e9e6819f240aea1871aa3a544f9aa4aede5f9e3abb585"
  end

  depends_on "gcc" => :test
  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/fprettify", "--version"
    (testpath/"test.f90").write <<~EOS
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
    EOS
    system "#{bin}/fprettify", testpath/"test.f90"
    ENV.fortran
    system ENV.fc, testpath/"test.f90", "-o", testpath/"test"
    system testpath/"test"
  end
end
