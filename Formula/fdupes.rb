class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.1.0/fdupes-2.1.0.tar.gz"
  sha256 "e5b9fb62e1d71779a64711384e3ab8de876b73fabcf3eabba8608022af92129e"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "a8923209aeca2d2d84a059138479ce569122408995484f415aa5d7fe4d89f9b8" => :catalina
    sha256 "cd0f54fb053da84b7039a11a29830e1129bc76a5b3d8a35ac2b4e0e2738d27f9" => :mojave
    sha256 "e4ea45cc84b1935038af9717f8d3efa158f3ec3ac2e04586134764d180365eeb" => :high_sierra
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
