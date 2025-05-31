class Pangene < Formula
  desc "Construct pangenome gene graphs"
  homepage "https://github.com/lh3/pangene"
  url "https://github.com/lh3/pangene/archive/refs/tags/v1.1.tar.gz"
  sha256 "9fbb6faa4d53b1e163a186375ca01bbac4395aa4c88d1ca00d155e751fb89cf8"
  license "MIT"
  head "https://github.com/lh3/pangene.git", branch: "main"

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "pangene"
    man1.install "pangene.1"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pangene --version")
    cp_r pkgshare/"test/C4/.", testpath
    output = shell_output("#{bin}/pangene 31_chimpanzee.paf.gz")
    assert_match "chimpanzee", output
  end
end
