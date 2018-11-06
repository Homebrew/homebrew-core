class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.11.tar.gz"
  sha256 "6cf46a8befef414b99933d3c0f9f58f3b3c7339dc11a744de7380c540d0f1ed4"

  bottle do
    cellar :any_skip_relocation
    sha256 "60e466d0262393caadaeb822fb9f006a6018df9ca6851cb95485412dbfa1c435" => :mojave
    sha256 "22083be28c6a7d610b2c04f766710f2f07367a3f1a571eeac1b287267ffba44c" => :high_sierra
    sha256 "0467bdff1e91566ec56ada84240068ca882500a3aecd33fd98b5901df9496ae9" => :sierra
    sha256 "080393ee6408d004a629c2427455eae484bb7f2edeaf993e2528a16e1c0055c0" => :el_capitan
  end

  # Fix for build issue, remove in next version
  # https://github.com/jbruchon/jdupes/issues/89
  patch do
    url "https://github.com/jbruchon/jdupes/commit/1a88f0ed.diff?full_index=1"
    sha256 "f086733421f08f93a96f88d7f6bc688761a498e8382250c30b02b0df869fa4f9"
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
