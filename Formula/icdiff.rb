class Icdiff < Formula
  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-1.9.4.tar.gz"
  sha256 "dabceff1986d45f1e0e6a396ed71836586acfb99092a91303f14052b879ca59a"
  head "https://github.com/jeffkaufman/icdiff.git"

  bottle :unneeded

  def install
    bin.install "icdiff", "git-icdiff"
  end

  test do
    (testpath/"file1").write "test1"
    (testpath/"file2").write "test2"
    system "#{bin}/icdiff", "file1", "file2"
    system "git", "init"
    system "#{bin}/git-icdiff"
  end
end
