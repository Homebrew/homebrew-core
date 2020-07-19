class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.1.1/fdupes-2.1.1.tar.gz"
  sha256 "5ab60e6c0b10438f3e323c6d14f34d2f3eec33cc4cd95159f220a1722613b1b2"
  license "MIT"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "13686b900c1c95aaa6904e4f007ef79185a46626722228ddcd273e8bd265c2f5" => :catalina
    sha256 "95ddd9ad27d0805991a64e7454b3a9abbd332aea0f893e1337dc3d2b14a06324" => :mojave
    sha256 "ad80afb06ccbdc78c055560549341b10d19fd7e1ccf6f832630bba1aef78cd6b" => :high_sierra
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
