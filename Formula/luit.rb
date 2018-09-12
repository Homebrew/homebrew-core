class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20180628.tgz"
  sha256 "7b84f63072589e9b03bb3e99e01ef344bb37793b76ad1cbb7b11f05000d64844"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c3dacfce73760ac50146bee7befa165a4ddf7f6bddae148777dfd9425f6cc9e" => :mojave
    sha256 "e2b66941a0cf7dfb7fe0b1c15917ca1586ccc77999a4f9e9a150fc08e4fd6f7c" => :high_sierra
    sha256 "a365a4654be845ee683827113bff9efa96832fbbd248234f3a785fd4d1ebb2ba" => :sierra
    sha256 "323633917450a82e0f86958f77be43d6fbfba4e262d8ea393473f72b0db9d304" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/luit", "-list"
  end
end
