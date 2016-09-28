class Cvs2svn < Formula
  desc "Tool for converting from CVS to Subversion"
  homepage "http://cvs2svn.tigris.org/"
  url "http://cvs2svn.tigris.org/files/documents/1462/49237/cvs2svn-2.4.0.tar.gz"
  sha256 "a6677fc3e7b4374020185c61c998209d691de0c1b01b53e59341057459f6f116"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dcbd1795c4158321006fd18dc20b66e9103f9b804527c500708560cee338cc2" => :sierra
    sha256 "139a3643daa18a5d601b36ae7e46c505a4f3b9eecc5d5e454bb8a070d2a399ca" => :el_capitan
    sha256 "2077e22472b23ac2ab3ce0db17bd7c91b0a37538df99e0092736bb0ef878f6b5" => :yosemite
    sha256 "845ab442991ff1eb312a27e0530e54e0e4986c280aa511eb59a626a2fe9c7b30" => :mavericks
  end

  # cvs2svn requires python with gdbm support
  depends_on "python"

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

  def caveats; <<-EOS.undent
    NOTE: man pages have been installed, but for better documentation see:
      #{HOMEBREW_PREFIX}/share/doc/cvs2svn/cvs2svn.html
    or http://cvs2svn.tigris.org/cvs2svn.html.

    Contrib scripts and example options files are installed in:
      #{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cvs2svn --version")
  end
end
