class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v4.1.0.tar.gz"
  sha256 "3983fa3f00d4bf85ba8e21f1a590f6e28938093abe0bb950aeea52b1717471fc"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "431b4435b5ebd04f168e66df26afa77d3f5ccb0e29be3c0f9e5fd72d8a23e01c" => :mojave
    sha256 "431b4435b5ebd04f168e66df26afa77d3f5ccb0e29be3c0f9e5fd72d8a23e01c" => :high_sierra
    sha256 "b849fe0d7470425a8472267a1291cec524798e225be668b124cd31b23a9eaf6f" => :sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
