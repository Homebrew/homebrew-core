class Icdiff < Formula
  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-1.9.1.tar.gz"
  sha256 "18cf11866150eba1ecec1370611921246918310f4b5cb101045db523a05fb37d"

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
