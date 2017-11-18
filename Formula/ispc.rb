class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://downloads.sourceforge.net/project/ispcmirror/v1.9.2/ispc-v1.9.2-osx.tar.gz"
  sha256 "aa307b97bea67d71aff046e3f69c0412cc950eda668a225e6b909dba752ef281"

  bottle :unneeded

  def install
    bin.install "ispc"
  end

  test do
    system "#{bin}/ispc", "-v"
  end
end
