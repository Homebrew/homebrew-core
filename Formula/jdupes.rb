class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.13.2.tar.gz"
  sha256 "41376ace274320a77e35ffed170ff0cbca2cd0cfd0ff1cea53d7464e97d4341f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5914122e74633a5d22c16102e0ffbf43c6a5d5903ecc75d41b050339af913b96" => :mojave
    sha256 "f2132c6e2a0a1402a0dcc0205efc2ae80fcc1e70508f1910db3113de0d64ce1d" => :high_sierra
    sha256 "95ce9083f5ee6dabdaae7ac9165b51231aa8df5240452f3eaec9c172064082cc" => :sierra
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
