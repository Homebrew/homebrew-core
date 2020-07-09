class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.18.1.tar.gz"
  sha256 "94b4822af20e632130c0ad75ba6183ab8009c4920718cf951805f5a49fe07954"

  bottle do
    cellar :any_skip_relocation
    sha256 "77044ba05558f7350dbe9bc3f29d69bd2f4d89ed22fb2d45c32d87728c8072b5" => :catalina
    sha256 "84bbdaae18f92323a0aa61c202e28bc41a106f706055c46cc8c447f347f8a84b" => :mojave
    sha256 "50be93168e95a07e3e70b37d07e4ebb6131b765149db624bd22411a3edffab7e" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
