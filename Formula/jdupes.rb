class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.18.2.tar.gz"
  sha256 "97a08107b97472472c6b4a8f9c18c44c1a17e6cc988e6f9747345f4b3141b43f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "48e80c556da93ea862b5a11488598fea312b8388a715ca68cb1f9ab102076e64" => :catalina
    sha256 "d568b3e8270e01560ad7e811045a1faa4497a823cb32a1bbcede8b75cdbb48f2" => :mojave
    sha256 "6bad9b9193239d7f39e5dd76fb6549add800b70ec4edad577b58552df17a622f" => :high_sierra
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
