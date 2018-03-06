class Diffuse < Formula
  desc "Graphical tool for merging and comparing text files"
  homepage "https://diffuse.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diffuse/diffuse/0.4.8/diffuse-0.4.8.tar.bz2"
  sha256 "c1d3b79bba9352fcb9aa4003537d3fece248fb824781c5e21f3fcccafd42df2b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4610d6231768f22f7c5a8a19aca5632a7485d9e9a85ba1cc0911f0aeeb01563e" => :high_sierra
    sha256 "4610d6231768f22f7c5a8a19aca5632a7485d9e9a85ba1cc0911f0aeeb01563e" => :sierra
    sha256 "4610d6231768f22f7c5a8a19aca5632a7485d9e9a85ba1cc0911f0aeeb01563e" => :el_capitan
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
