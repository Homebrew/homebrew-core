class Makeself < Formula
  desc "Generates a self-extracting compressed tar archive"
  homepage "http://www.megastep.org/makeself/"
  url "https://github.com/megastep/makeself/archive/release-2.4.4.tar.gz"
  sha256 "3ca30c6b60a873cf0e44c0d47e9778a46ec0ca2ba8feffb1dd62a34cc2226395"
  license "GPL-2.0-or-later"
  head "https://github.com/megastep/makeself.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "620fe1bac044be0d0cc0c37bd3683151f90ce479fcd2736bf27fcf59b0da2edc"
  end

  def install
    # Replace `/usr/local` references to make bottles uniform
    inreplace ["makeself-header.sh", "makeself.sh"], "/usr/local", HOMEBREW_PREFIX
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
