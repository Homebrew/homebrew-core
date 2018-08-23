class Icdiff < Formula
  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-1.9.3.tar.gz"
  sha256 "090b0f96c5df5ae5d71f6e5325bca566dd47e8b61ec4b59d4e40acb9ffcb878f"
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
