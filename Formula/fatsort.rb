class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.4.2.439.tar.xz"
  version "1.4.2"
  sha256 "bdbcf99307baef3e76d99700691ac525c9a9cf96d8433b45c89314940cc6a1e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f9f2b6c33f3020aab2b7edad6ba01be97170cc128515179df3d03cab55ff894" => :mojave
    sha256 "83d3f92d45b4ed4cf71453c07a6728841d5329957ff681ef29419067397d7e83" => :high_sierra
    sha256 "d4742a8453bf67a815b862328b3714b1b30d7633688496b18350114e7c2acdd4" => :sierra
    sha256 "96cc7c6ad5e64d86121b27e9d86ef33e1d2a6e9abde741253c0f06cf76249c8f" => :el_capitan
    sha256 "717b1b1c912dd49ee1d034e640f9fcdd556634e2a29fd01da195e5e6a1e9f48b" => :yosemite
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
