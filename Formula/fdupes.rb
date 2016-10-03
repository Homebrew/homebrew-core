class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/archive/v1.6.1.tar.gz"
  sha256 "9d6b6fdb0b8419815b4df3bdfd0aebc135b8276c90bbbe78ebe6af0b88ba49ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "8921764424eeab34f7c58cfd9f89cf912ce5d64954c43ff6f6631d7a651ae190" => :sierra
    sha256 "540da176405c0c3e49538ae782c007004cbdb9eb42b311e398662fc7e53b62b4" => :el_capitan
    sha256 "18d3554d18a97835290320404bea4a502c0f0399fa9985b1e672114af861bc0d" => :yosemite
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
