class Boxes < Formula
  desc "Draw boxes around text"
  homepage "http://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v1.2.tar.gz"
  sha256 "ba237f6d4936bdace133d5f370674fd4c63bf0d767999a104bada6460c5d1913"
  head "https://github.com/ascii-boxes/boxes.git"

  bottle do
    sha256 "ebb5d353fb518ceb79ad3f52c0e53e867c5fc7bef1577cdca712ce91e522af56" => :sierra
    sha256 "6f0a27e8bad4e4294bf4b4f82d1774eaf987cc7e8e6486f3204619ab84f01b13" => :el_capitan
    sha256 "ae79b8cff43636d551a7f3e34dd74c5d6c15c526c79b6a9ad6b0fb2d3b60c0e0" => :yosemite
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
