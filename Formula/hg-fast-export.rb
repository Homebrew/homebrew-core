class HgFastExport < Formula
  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v190913.tar.gz"
  sha256 "f1d30976d242f679676d8e6d54eff108ef785edd918b7a3c3195e1d510923bcc"

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
