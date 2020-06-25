class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.17.0.tar.gz"
  sha256 "e0a54082d4130f1d0450ccd605ad380da9038d53c915edc67b4ea6b21cfb32c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aad04e681cc460137a9b9aba7744d6175622faab96c230f4063476e908594e0" => :catalina
    sha256 "7da2491ea59a6af5c308a9963b94d318caeb90c22abf968a350af364e0df1469" => :mojave
    sha256 "1b7cd621bd39e56b50936e0602b06d2f065f055664ff5d3684d072944c715764" => :high_sierra
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
