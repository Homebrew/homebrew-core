class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.7.679.tar.xz"
  version "1.7"
  sha256 "1012f551382639d69e194eabfbe99342ede7c856b1cd6788287f9dfd4bd8d122"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/fatsort[._-]v?(\d+(?:\.\d+)+)\.\d+\.t}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf6f852b979722c1ee0872145e63a023fa6158208171ba6b09d0b6a37592a484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4f6537b80d60554df73f54ed1a54b5b6d83750c846df7268d59926e890bc9f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "080c536f78906bd19a2d01047f00f56a3595cb8549eae90eebaec620885cd510"
    sha256 cellar: :any_skip_relocation, sonoma:        "6de023bfeb092ada2d2c2383a42ce7b1e05a27726dbfe8da14768ceefdeb4479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0847ede369e638a6ccdd1eeb2d4f9326eda6f5985797cca203fcbd13c8d9150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c24a2626f64986a87fa2b9933bac0b029632c684e25ec20ee1fa5156bd4e8b6"
  end

  depends_on "help2man"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "src/fatsort"
    man1.install "man/fatsort.1"
  end

  test do
    system bin/"fatsort", "--version"
  end
end
