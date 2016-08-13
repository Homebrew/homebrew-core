class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://downloads.sourceforge.net/project/ispcmirror/v1.9.1/ispc-v1.9.1-osx.tar.gz"
  sha256 "ee949fcdf37ad3e3c0b946e6d6e32d7a7eafcec43e2cb908aea7e58e78bb0f55"

  bottle :unneeded

  def install
    bin.install "ispc"
  end

  test do
    system "#{bin}/ispc", "-v"
  end
end
