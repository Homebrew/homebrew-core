class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.9.2.tar.gz"
  sha256 "76a14e22f05a52fb0b30142686a6cb144b0415b39be6c9fcd3f17ac23447f0b2"
  revision 1

  bottle do
    cellar :any
    sha256 "69c12c8e3a068b9d3c1361ad5af915316875d50ffd91eeca03d54de81692e4fa" => :mojave
    sha256 "3aed8cf86cb9cb7329b5fcb5cb81fae74d2d5fb61bc65b5e6d36525b0f7ae12c" => :high_sierra
    sha256 "21ecdffa7a0594da5882b01c83b60d17e97d588fe5f676d87fdc3d0491039592" => :sierra
    sha256 "403bd415fab378038524a4981c4ac21aac6bfa72b77348a454d89ef27b554a4f" => :el_capitan
  end

  depends_on "bison" => :build
  depends_on "llvm@4" => :build

  def install
    system "make"
    bin.install "ispc"
  end

  test do
    system "#{bin}/ispc", "-v"
  end
end
