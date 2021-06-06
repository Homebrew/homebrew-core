class Makeself < Formula
  desc "Generates a self-extracting compressed tar archive"
  homepage "https://makeself.io/"
  url "https://github.com/megastep/makeself/archive/release-2.4.4.tar.gz"
  sha256 "3ca30c6b60a873cf0e44c0d47e9778a46ec0ca2ba8feffb1dd62a34cc2226395"
  license "GPL-2.0-or-later"
  head "https://github.com/megastep/makeself.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "021212c284a4bc65cd332a2863d54ddadd73db4439c13366159fc88c95e5a18a"
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
