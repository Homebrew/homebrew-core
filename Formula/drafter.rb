class Drafter < Formula
  desc "API Blueprint document parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v3.2.7/drafter-v3.2.7.tar.gz"
  sha256 "a2b7061e2524804f153ac2e80f6367ae65dfcd367f4ee406eddecc6303f7f7ef"

  def install
    system "./configure", "--shared"
    system "make", "drafter"
    bin.install "bin/drafter"
    (include + "drafter").install "src/drafter.h"
    lib.install "build/out/Release/libdrafter.dylib"
  end

  test do
    system bin/"drafter", "--help"
  end
end
