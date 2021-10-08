class Fpocket2 < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://fpocket.sourceforge.io/"
  url "https://netcologne.dl.sourceforge.net/project/fpocket/fpocket2.tar.gz"
  sha256 "76c90514e3e81d8068007ecabfe8454699bee8bf22fea384b3cb14879c105668"
  license "GPL-3.0-or-later"

  def install
    system "sed -i 's/\$(LFLAGS) \$\^ -o \$@/\$\^ -o \$@ \$(LFLAGS)/g' makefile" if OS.linux?
    system "make"
    bin.install Dir["bin/*pocket"]
    bin.install "bin/pcheck"
  end

  test do
    system "#{bin}/pcheck"
  end
end
