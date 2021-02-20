class Makeself < Formula
  desc "Generates a self-extracting compressed tar archive"
  homepage "http://www.megastep.org/makeself/"
  url "https://github.com/megastep/makeself/archive/release-2.4.3.tar.gz"
  sha256 "b4c81c3d0a7c81459459319e9fc75320e057ea908430aa8a020be1993d6b74c8"
  license "GPL-2.0-or-later"
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
