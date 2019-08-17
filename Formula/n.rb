class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.0.0.tar.gz"
  sha256 "f7e77b6eb69cb4bbd06875ee5a5aec737143c0963e0a5faaf0b84368798686a2"
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
