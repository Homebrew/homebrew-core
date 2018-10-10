class Cvs2svn < Formula
  desc "Tool for converting from CVS to Subversion"
  homepage "http://cvs2svn.tigris.org/"
  url "http://cvs2svn.tigris.org/files/documents/1462/49543/cvs2svn-2.5.0.tar.gz"
  sha256 "6409d118730722f439760d41c08a5bfd05e5d3ff4a666050741e4a5dc2076aea"

  bottle do
    cellar :any_skip_relocation
    sha256 "56ec125399395caadd7b419d484d7403a7f638135ef36d46960d24234578c846" => :mojave
    sha256 "2f09535e501bc80b9cd4b911b678e2e583a4eba9cd4d91be41e80b1f768f4631" => :high_sierra
    sha256 "147e9169c114da7c54cf8e35ea15c0e00213f49416f11c13f9d205cf4dd715b4" => :sierra
    sha256 "c3c7bfaf4dd467504aecd039742152ce173529c6d3ff53ef0d6e2cbee0d5f5e6" => :el_capitan
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
