class GitNumber < Formula
  desc "Use numbers for dealing with files in git"
  homepage "https://github.com/holygeek/git-number"
  url "https://github.com/holygeek/git-number/archive/1.0.1.tar.gz"
  sha256 "1b9e691bd2c16321a8b83b65f2393af1707ece77e05dab73b14b04f51e9f9a56"

  bottle do
    cellar :any_skip_relocation
    sha256 "d71548120a8d5d9db4b9b9ae71be947303c6a415e35380d0d8e36551765b827f" => :high_sierra
    sha256 "d71548120a8d5d9db4b9b9ae71be947303c6a415e35380d0d8e36551765b827f" => :sierra
    sha256 "d71548120a8d5d9db4b9b9ae71be947303c6a415e35380d0d8e36551765b827f" => :el_capitan
  end

  def install
    system "make", "test"
    system "make", "prefix=#{prefix}", "install"
  end
end
