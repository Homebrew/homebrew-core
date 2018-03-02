class Cvs2svn < Formula
  desc "Tool for converting from CVS to Subversion"
  homepage "http://cvs2svn.tigris.org/"
  url "http://cvs2svn.tigris.org/files/documents/1462/49237/cvs2svn-2.4.0.tar.gz"
  sha256 "a6677fc3e7b4374020185c61c998209d691de0c1b01b53e59341057459f6f116"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2f09535e501bc80b9cd4b911b678e2e583a4eba9cd4d91be41e80b1f768f4631" => :high_sierra
    sha256 "147e9169c114da7c54cf8e35ea15c0e00213f49416f11c13f9d205cf4dd715b4" => :sierra
    sha256 "c3c7bfaf4dd467504aecd039742152ce173529c6d3ff53ef0d6e2cbee0d5f5e6" => :el_capitan
  end

  # cvs2svn requires python with gdbm support
  depends_on "python@2"

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

  def caveats; <<~EOS
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
