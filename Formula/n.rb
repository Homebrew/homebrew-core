class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v5.0.2.tar.gz"
  sha256 "c8fa32cf291df33c008096bb9a583f7d389e50c21238a4c6f39a2f427c37aaa7"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4a345240f8eb66b3ab9ee26691650d81e867b82ca7131b585918dbea0d94eeb" => :mojave
    sha256 "b4a345240f8eb66b3ab9ee26691650d81e867b82ca7131b585918dbea0d94eeb" => :high_sierra
    sha256 "7416bdf89bbea0fc4fc89b60906f150fb9537a123f1120893ebd2bba15ab1f4e" => :sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
