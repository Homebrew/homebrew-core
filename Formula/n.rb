class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v5.0.2.tar.gz"
  sha256 "c8fa32cf291df33c008096bb9a583f7d389e50c21238a4c6f39a2f427c37aaa7"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81eb46b1e8aa88b8dd756550b839c278e4b2ece9617cd5e6c2f6998cfb630fd6" => :mojave
    sha256 "81eb46b1e8aa88b8dd756550b839c278e4b2ece9617cd5e6c2f6998cfb630fd6" => :high_sierra
    sha256 "cbea8d6f66d37a1de7c56cc6d4e3be04d975379e9911c4f80ca65dc7993aa3c2" => :sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
