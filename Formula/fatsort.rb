class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.6.3.622.tar.xz"
  version "1.6.3"
  sha256 "481c94ea08f6faaafe67594726d70fb3e3d5ac9672745f0034e55134ea5256fc"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/fatsort[._-]v?(\d+(?:\.\d+)+)\.\d+\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c3e2a36f45f08826087b89279cb36c9156024d4ecc0e02a1218dd28d27c6d8b7" => :catalina
    sha256 "3f70bababd3108670a3752056ed24b76187df9d82beae1581645b91945cdde2d" => :mojave
    sha256 "fdecaa643274a1e780ff530801c88cb92a66a49639ced214b29c4703389e0dd7" => :high_sierra
  end

  depends_on "help2man"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "src/fatsort"
    man1.install "man/fatsort.1"
  end

  test do
    system "#{bin}/fatsort", "--version"
  end
end
