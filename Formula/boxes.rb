class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v1.3.tar.gz"
  sha256 "cbb46b3b0ef2c016f9ebcebea5acf6c2bfec39dfb6696dc8f4427a3f844cd567"
  head "https://github.com/ascii-boxes/boxes.git"

  bottle do
    sha256 "48a3b6d9b8c23a3ab1f366f6f085361cc8db8cd341dfe9474665d87c4c23bbf8" => :catalina
    sha256 "84b135ad528536233546dbf8d36e0be4a21a89050910e45a4f8e2796c99b7c3f" => :mojave
    sha256 "ca1c4e0e76f03ee4a60789f30093d2eee3794ff54b989da1a8a3ae555228f081" => :high_sierra
    sha256 "d31462128d1f55cd3014ae942b4620f1ec4d06e72e8a47cae5ef56afcf65e791" => :sierra
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
