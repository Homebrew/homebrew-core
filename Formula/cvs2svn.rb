class Cvs2svn < Formula
  desc "Tool for converting from CVS to Subversion"
  homepage "http://cvs2svn.tigris.org/"
  url "http://cvs2svn.tigris.org/files/documents/1462/49543/cvs2svn-2.5.0.tar.gz"
  sha256 "6409d118730722f439760d41c08a5bfd05e5d3ff4a666050741e4a5dc2076aea"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0d7b7b145ca61199a8d3df0c8573e8b6b189cc5a347271ccd02569842e530c8" => :mojave
    sha256 "ff57f2529923038acef70f6e307d42500986ccdbdcd2e182b2bdae140e02c23f" => :high_sierra
    sha256 "979b006250f9c1ecb03b6b7695e15bf7a7981738a584aec6ddcea3af680770fb" => :sierra
  end

  depends_on "python@2" # does not support Python 3

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    system "make", "man"
    man1.install gzip("cvs2svn.1", "cvs2git.1", "cvs2bzr.1")
    prefix.install %w[ BUGS COMMITTERS HACKING
                       cvs2bzr-example.options
                       cvs2git-example.options
                       cvs2hg-example.options
                       cvs2svn-example.options contrib ]
    doc.install Dir["{doc,www}/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cvs2svn --version")
  end
end
