class HgFastExport < Formula
  desc "Mercurial to git converter using git-fast-import"
  homepage "https://packages.debian.org/source/sid/hg-fast-export"
  url "http://http.debian.net/debian/pool/main/h/hg-fast-export/hg-fast-export_20140308.orig.tar.gz"
  version "20140308"
  sha256 "340f0aa4ba0180164eee01b3ef14f709006399770819e64a1d84d761a3e5ebd3"

  head "git://repo.or.cz/fast-export.git"

  def install
    bin.install "hg-fast-export.py", "hg-fast-export.sh",
                "hg-reset.py", "hg-reset.sh",
                "hg2git.py"
  end

  test do
    system bin/"hg-reset.sh", "-h"
  end
end
