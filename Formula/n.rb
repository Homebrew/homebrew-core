class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.3.1.tar.gz"
  sha256 "cbb30fc25e1942507a2ef116bbb35e7ab6f63772f0126d49b801d0c4d2f38c6b"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e9ea122f44880fe1c00b62b1fd4237efb9e089234c09bb3707b549ac6cc3d4b" => :catalina
    sha256 "3e9ea122f44880fe1c00b62b1fd4237efb9e089234c09bb3707b549ac6cc3d4b" => :mojave
    sha256 "3e9ea122f44880fe1c00b62b1fd4237efb9e089234c09bb3707b549ac6cc3d4b" => :high_sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
