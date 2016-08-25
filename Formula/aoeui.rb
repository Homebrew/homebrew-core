class Aoeui < Formula
  desc "Lightweight text editor optimized for Dvorak and QWERTY keyboards"
  homepage "https://github.com/pklausler/aoeui"
  url "https://github.com/pklausler/aoeui/raw/03ff419acb2d6669ea48b5640398c44528f662eb/aoeui-1.7.tgz"
  sha256 "f4c067ad2c3b95ad130411195dd53ea49300e8e3496ecf0deceff20350c7670d"
  head "https://github.com/pklausler/aoeui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62a04ac0fd27e76f4f77da95e7d5aaf75488765f98b02574ae7dff0508cd9f13" => :el_capitan
    sha256 "19f622466c20ad4ddff2fc97ac186e189d5a8bb02dd405ed2a93c5d13a88b1f4" => :yosemite
    sha256 "a3ac3238356624a12b20df52c98d2bc52e0d785745e393928fc4c629212d1406" => :mavericks
  end

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
