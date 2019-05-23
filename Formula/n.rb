class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v4.1.0.tar.gz"
  sha256 "3983fa3f00d4bf85ba8e21f1a590f6e28938093abe0bb950aeea52b1717471fc"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b753e68ce91be4af36cec742a7e6d7a2cb3242fe09ba5a4147a463a80d47e2c2" => :mojave
    sha256 "b753e68ce91be4af36cec742a7e6d7a2cb3242fe09ba5a4147a463a80d47e2c2" => :high_sierra
    sha256 "4d118086a61cd984b8459fb2144d03ed3ec35e62da7ed5b04f0f1a7578827d54" => :sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
