class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.5.0.456.tar.xz"
  version "1.5.0"
  sha256 "a835b47814fd30d5bad464b839e9fc404bc1a6f5a5b1f6ed760ce9744915de95"

  bottle do
    cellar :any_skip_relocation
    sha256 "30317b1edc9c062183ca98bf20baca935bf129405e15fc89056659968e33a83b" => :mojave
    sha256 "d9e23a82a00b9747f24e78e2fc11f40ea8bebadfafa41fa7d5c2e6838d6514b7" => :high_sierra
    sha256 "fd941f1bc940edcd9d23860ce723355be2249e330ecc8bbab4c5713525c78963" => :sierra
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
