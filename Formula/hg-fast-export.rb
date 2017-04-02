class HgFastExport < Formula
  desc "Fast Mercurial to Git converter"
  homepage "http://repo.or.cz/w/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v160914.tar.gz"
  sha256 "1eb2c520f9fa93413d17e4a4551e3dde0dad31564498f1204b191741bd5a4763"

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
