class Fprettify < Formula
  include Language::Python::Virtualenv

  desc "Auto-formatter for modern fortran source code"
  homepage "https://github.com/pseewald/fprettify/"
  url "https://github.com/pseewald/fprettify/archive/v0.3.7.tar.gz"
  sha256 "052da19a9080a6641d3202e10572cf3d978e6bcc0e7db29c1eb8ba724e89adc7"
  license "GPL-3.0-or-later"
  head "https://github.com/pseewald/fprettify.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27bfb5c470eeb3ab6bdae65b9fd1c58b6c44eb358c159f9ca0611333ddf3c6ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c40bc2e5dd99d941bea03a38817fd148c1584a85c4b0ec37c3fe32ff2a8aabb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a101c7b0dfd55728979e0fff9eeedf52967cb67d4351a74c0c114a3854ff3bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3fd405fa4587e33aa07426cba0252284bbdaf5471b5d303321c13d01bf179c7"
    sha256 cellar: :any_skip_relocation, ventura:        "d76d7a276834cd2f4a2ded83fe4815e7ab23cfee7140bd5f85fbf9409a9be5fa"
    sha256 cellar: :any_skip_relocation, monterey:       "8b307249b02b0a4e2828ca9f6e4cf44c52f77edb1974e9afc9c169cabec647da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "504f99c368a69c813ada09fe586a0e241691177cab747f40b7100423b9886a6a"
  end

  depends_on "gcc" => :test
  depends_on "python@3.12"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

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
