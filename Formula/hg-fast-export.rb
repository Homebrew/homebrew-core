class HgFastExport < Formula
  desc "Fast Mercurial to Git converter"
  homepage "http://repo.or.cz/w/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v170624.tar.gz"
  sha256 "f46963ba643c509f32733384b40cdb98f058f25211cd7c107056285efa83148f"

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
