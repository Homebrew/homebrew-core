class Makeself < Formula
  desc "Make self-extractable archives on UNIX"
  homepage "http://www.megastep.org/makeself/"
  url "https://github.com/megastep/makeself/archive/release-2.3.0.tar.gz"
  sha256 "e89ceeabc28246e62887177942adc9c466c9eab04809a2854eb42c6ce66630fa"
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
