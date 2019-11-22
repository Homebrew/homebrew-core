class GitNumber < Formula
  desc "Use numbers for dealing with files in git"
  homepage "https://github.com/holygeek/git-number"
  url "https://github.com/holygeek/git-number/archive/1.0.1.tar.gz"
  sha256 "1b9e691bd2c16321a8b83b65f2393af1707ece77e05dab73b14b04f51e9f9a56"

  bottle do
    cellar :any_skip_relocation
    sha256 "662840b36a99f95902aee618faed6274d2cf9c6620b9c01855377d85d838eaad" => :catalina
    sha256 "2fc24b4bb5404f85fb6c359ac9b8c969846953176d8a01176c4e6ddba3067bc9" => :mojave
    sha256 "d71548120a8d5d9db4b9b9ae71be947303c6a415e35380d0d8e36551765b827f" => :high_sierra
    sha256 "d71548120a8d5d9db4b9b9ae71be947303c6a415e35380d0d8e36551765b827f" => :sierra
    sha256 "d71548120a8d5d9db4b9b9ae71be947303c6a415e35380d0d8e36551765b827f" => :el_capitan
  end

  def install
    system "make", "test"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/git-number", "-v"
  end
end
