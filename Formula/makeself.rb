class Makeself < Formula
  desc "Make self-extractable archives on UNIX"
  homepage "http://www.megastep.org/makeself/"
  url "https://github.com/megastep/makeself/archive/release-2.4.2.tar.gz"
  sha256 "8789312db5e93fc471a1e4fb88ec13227ef63a9c7aad297f3bbf35f9511f8d62"
  head "https://github.com/megastep/makeself.git"

  bottle :unneeded

  def install
    libexec.install "makeself-header.sh"
    # install makeself-header.sh to libexec so change its location in makeself.sh
    inreplace "makeself.sh", '`dirname "$0"`', libexec
    bin.install "makeself.sh" => "makeself"
    man1.install "makeself.1"
  end

  test do
    touch "testfile"
    system "tar", "cvzf", "testfile.tar.gz", "testfile"
    system "#{bin}/makeself", ".", "testfile.run", '"A test file"', "echo"
  end
end
