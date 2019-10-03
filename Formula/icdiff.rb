class Icdiff < Formula
  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-1.9.5.tar.gz"
  sha256 "f2e3df30e93df92224538ef3c62a73891af92de4caf94e8117582835e1040fc7"
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
