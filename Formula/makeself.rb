class Makeself < Formula
  desc "Make self-extractable archives on UNIX"
  homepage "http://www.megastep.org/makeself/"
  url "https://github.com/megastep/makeself/archive/release-2.3.1.tar.gz"
  sha256 "72211fab8e6e34ec16acded47203c9fff2a3f1313c9ebd4330f6c94ffea43993"
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
