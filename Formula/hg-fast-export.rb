class HgFastExport < Formula
  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v180610.tar.gz"
  sha256 "b5ee4fa5b797c4941b447fe3bff543f868b19e24c09c1dbbccf33438120dc36a"

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
