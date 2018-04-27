class Makeself < Formula
  desc "Make self-extractable archives on UNIX"
  homepage "http://www.megastep.org/makeself/"
  url "https://github.com/megastep/makeself/archive/release-2.4.0.tar.gz"
  sha256 "76a8c3f3fad1b55c39ba2904a19e74962151f9481df03091d4e54938bdd13f50"
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
