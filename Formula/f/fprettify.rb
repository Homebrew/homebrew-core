class Fprettify < Formula
  include Language::Python::Virtualenv

  desc "Auto-formatter for modern fortran source code"
  homepage "https://github.com/pseewald/fprettify/"
  url "https://github.com/pseewald/fprettify/archive/v0.3.7.tar.gz"
  sha256 "052da19a9080a6641d3202e10572cf3d978e6bcc0e7db29c1eb8ba724e89adc7"
  license "GPL-3.0-or-later"
  head "https://github.com/pseewald/fprettify.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eaf9f8515de83e38a2279f945676e4c634b7831f91095b1da7321fc58dcb39c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eaf9f8515de83e38a2279f945676e4c634b7831f91095b1da7321fc58dcb39c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4eaf9f8515de83e38a2279f945676e4c634b7831f91095b1da7321fc58dcb39c"
    sha256 cellar: :any_skip_relocation, ventura:        "e7bf15a8edcf12f4aa936c7da9ce8e771f84a9e4177897351a87d25d1f281ba6"
    sha256 cellar: :any_skip_relocation, monterey:       "e7bf15a8edcf12f4aa936c7da9ce8e771f84a9e4177897351a87d25d1f281ba6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7bf15a8edcf12f4aa936c7da9ce8e771f84a9e4177897351a87d25d1f281ba6"
    sha256 cellar: :any_skip_relocation, catalina:       "e7bf15a8edcf12f4aa936c7da9ce8e771f84a9e4177897351a87d25d1f281ba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51fb193432c7ed43d63e9b13a8e946058f91277e3d601abfa7f5de25f56a4b70"
  end

  depends_on "gcc" => :test
  depends_on "python@3.11"

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
