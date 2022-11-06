class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.33.tar.gz"
  sha256 "f48b2547313ffd1799c58c6a170175176131bbd42bc847b5650784eaf6d914b3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d66adcc988a7a797a294859423891e290ab3c21bcf5b440f33a3537b66092310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f0c022777c3de70e1054f6cd50e135c15799185fa522ceeee7efbf574c9849c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32ad4359f19c1d9c067fc879215983096d3fbeb0ba2373a085afed072cf81fd1"
    sha256 cellar: :any_skip_relocation, monterey:       "79cd5ed1fa485a0ed61c87b65c53f3b8f9b96e56fe60a13b1c52784606e0a679"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc32a1ee88a4b745034be74ae1a1f555589a99ca65fdeb57fb28e41000b96433"
    sha256 cellar: :any_skip_relocation, catalina:       "f2f24b2215efcb1bbf2604c21a4dde80813f82e69b87e1a9bbaf9adedd90e96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5690deaa80f5cf2180d50d5e35a9b92ee60431b3f370639c7908fcbb5624150b"
  end

  uses_from_macos "zlib"

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
