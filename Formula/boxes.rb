class Boxes < Formula
  desc "Draw boxes around text"
  homepage "http://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v1.1.3.tar.gz"
  sha256 "4087ca01413c0aa79d4b9dcaf917e0a91721e5de76e8f6a38d1a16234e8290bf"
  head "https://github.com/ascii-boxes/boxes.git"

  bottle do
    sha256 "5715225d1b80a729ce073906aad9a785c03cb4df064dfde0683595dc2fceb51b" => :sierra
    sha256 "b34022a6136281c73eec0d470cf6cf1c520e681ca50055b0a026ba2430542ab8" => :el_capitan
    sha256 "6c7f30eb447ce1c54d073aa3b8aa16611671522d709a460a8a53d08063a68d6b" => :yosemite
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
