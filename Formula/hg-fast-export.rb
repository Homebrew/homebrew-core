class HgFastExport < Formula
  desc "Fast Mercurial to Git converter"
  homepage "http://repo.or.cz/w/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v160415.tar.gz"
  sha256 "0e8a8c27110f200b52be55d13858045ed069ae60a51b4d8878a310426d244316"

  head "git://repo.or.cz/fast-export.git"

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
