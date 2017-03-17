class Boxes < Formula
  desc "Draw boxes around text"
  homepage "http://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v1.1.3.tar.gz"
  sha256 "4087ca01413c0aa79d4b9dcaf917e0a91721e5de76e8f6a38d1a16234e8290bf"
  head "https://github.com/ascii-boxes/boxes.git"

  bottle do
    sha256 "20ab01b5e25afba5ee98838faf4efe25f0b9c1ca729ab1e6b5136cb09423ef67" => :sierra
    sha256 "bb0d5b9f24c531aaa9b45e09868073547ac0f1bc94ed39021c03f31cf8ed284b" => :el_capitan
    sha256 "8fe10850d2df635ca8800e826fa542be10e47a8c1a9da8ed2111245c61129ff7" => :yosemite
  end

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config", "CC=#{ENV.cc}"

    bin.install "src/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "test brew", pipe_output("#{bin}/boxes", "test brew")
  end
end
