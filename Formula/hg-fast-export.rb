class HgFastExport < Formula
  desc "Fast Mercurial to Git converter"
  homepage "http://repo.or.cz/w/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v171002.tar.gz"
  sha256 "792a1ec991e1f6fa5fc5a0c7de2b2236d813ade54d6554e5a390c88b546c7505"

  bottle :unneeded

  def install
    bin.install "hg-fast-export.py", "hg-fast-export.sh",
                "hg-reset.py", "hg-reset.sh",
                "hg2git.py"
  end

  test do
    system bin/"hg-fast-export.sh", "--help"
  end
end
