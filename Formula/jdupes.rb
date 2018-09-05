class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.10.2.tar.gz"
  sha256 "6c79035e2d349d0b1d749881b06a24ca43afc5b8f7e714c99b90a34b4618ed4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "60e466d0262393caadaeb822fb9f006a6018df9ca6851cb95485412dbfa1c435" => :mojave
    sha256 "22083be28c6a7d610b2c04f766710f2f07367a3f1a571eeac1b287267ffba44c" => :high_sierra
    sha256 "0467bdff1e91566ec56ada84240068ca882500a3aecd33fd98b5901df9496ae9" => :sierra
    sha256 "080393ee6408d004a629c2427455eae484bb7f2edeaf993e2528a16e1c0055c0" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
