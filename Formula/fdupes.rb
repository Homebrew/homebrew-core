class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/archive/v1.6.1.tar.gz"
  sha256 "9d6b6fdb0b8419815b4df3bdfd0aebc135b8276c90bbbe78ebe6af0b88ba49ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c018485d72b6181688d420bf9b72b47abfbf3fe079e36c3cd340a8dfab21da4" => :sierra
    sha256 "8f10660bba1b3ed324d06348c77dd2367942c25992b4e24bdf89b2c7fe6bec1d" => :el_capitan
    sha256 "b991062a505bdc31b1cee523b09465d5f83b0eaf78579029879d558a042f2112" => :yosemite
    sha256 "6b4a3d6d54bae82b8f41975aad6b90c440ccb95901a909fee594bbbc7b0be1db" => :mavericks
    sha256 "d8e9918fda3c8499aef07cc4a0d0f1b7b0a39932b6ff69f1e96583213bac3657" => :mountain_lion
  end

  def install
    inreplace "Makefile", "gcc", "#{ENV.cc} #{ENV.cflags}"
    system "make", "fdupes"
    bin.install "fdupes"
    man1.install "fdupes.1"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
