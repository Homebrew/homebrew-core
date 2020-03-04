class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.25.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.25.tar.lz"
  sha256 "ce538ebd26a09f45da67d3ad3f7431932428231ceec7a2d255f716fa231a1063"

  bottle do
    cellar :any_skip_relocation
    sha256 "517175b22fc4cc660059801b497484ffd7096ade308222c752e758f5036f570a" => :catalina
    sha256 "73234513fd966432d0cd11f907614b350c6943b3d2c82a7d1ed487fa93f948ca" => :mojave
    sha256 "a4090204da6b3ef1ff36ff144dd7737e42424e7adf59519becd76ca134cbc08c" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", "/dev/null"
  end
end
