class HgFastExport < Formula
  desc "Fast Mercurial to Git converter"
  homepage "http://repo.or.cz/w/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v180126.tar.gz"
  sha256 "7cf77d61dba0b4e8e2a1f2c6cb3cf885845f992c6231d6bf7f075bd34999a8f9"

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
