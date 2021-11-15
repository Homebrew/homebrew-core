class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.25.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.25.tar.lz"
  sha256 "ce538ebd26a09f45da67d3ad3f7431932428231ceec7a2d255f716fa231a1063"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9b1ace4f31c45defdbebb920946d10b0a88dffd9168d70074878a6052bdeb85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b5da0044c6ad27c1d0abf8aa373f67d37fe1a1ac6dcd90194f937cf7b4dc005"
    sha256 cellar: :any_skip_relocation, monterey:       "80612db48e7354cb9f95d3da871725eccbcc4bc603ba7d532655a90d7ab1437e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1ebbe84c3f44fd8b7d18e2889562a65c8043e3b4c8c4f96164cc42b3a096187"
    sha256 cellar: :any_skip_relocation, catalina:       "517175b22fc4cc660059801b497484ffd7096ade308222c752e758f5036f570a"
    sha256 cellar: :any_skip_relocation, mojave:         "73234513fd966432d0cd11f907614b350c6943b3d2c82a7d1ed487fa93f948ca"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a4090204da6b3ef1ff36ff144dd7737e42424e7adf59519becd76ca134cbc08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c12145d650e699749b0152a50925cf94fad2ea02d13e0e39520b5497fc251e5"
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
