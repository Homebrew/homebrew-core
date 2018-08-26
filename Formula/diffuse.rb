class Diffuse < Formula
  desc "Graphical tool for merging and comparing text files"
  homepage "https://diffuse.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diffuse/diffuse/0.4.8/diffuse-0.4.8.tar.bz2"
  sha256 "c1d3b79bba9352fcb9aa4003537d3fece248fb824781c5e21f3fcccafd42df2b"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "2d46d21ca9a0e4e744410d594fdc94a1aa37aa3ee30154b49a36cc071b21933a" => :mojave
    sha256 "e3e546b4693f94b65f72bb9026dce74bb904fa33aceb6385903a8753caaa28f7" => :high_sierra
    sha256 "e3e546b4693f94b65f72bb9026dce74bb904fa33aceb6385903a8753caaa28f7" => :sierra
    sha256 "e3e546b4693f94b65f72bb9026dce74bb904fa33aceb6385903a8753caaa28f7" => :el_capitan
  end

  depends_on "pygtk"

  def install
    system "python", "./install.py",
                     "--sysconfdir=#{etc}",
                     "--examplesdir=#{share}",
                     "--prefix=#{prefix}"
    inreplace bin/"diffuse", %r{^#!/usr/bin/env python$}, "#!/usr/bin/python"
  end

  test do
    system "#{bin}/diffuse", "--help"
  end
end
