class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.1.2/fdupes-2.1.2.tar.gz"
  sha256 "cd5cb53b6d898cf20f19b57b81114a5b263cc1149cd0da3104578b083b2837bd"
  license "MIT"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "e77144bd7d4b3ed472590b0bb7cb99dea185cf57b5b645bb0558c312441624c0" => :catalina
    sha256 "d9504149274c97eb7edb268d43ff18ebd292046d4c5691ae7c7aa9d16b40b0b3" => :mojave
    sha256 "0bd9b7c00c454042c485b1839ce6cef7f42af21710aa0d83f64a51ab5b18bfe2" => :high_sierra
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
