class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.9.2.tar.gz"
  sha256 "76a14e22f05a52fb0b30142686a6cb144b0415b39be6c9fcd3f17ac23447f0b2"
  revision 1

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
