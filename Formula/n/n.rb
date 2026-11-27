class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "3fbcf08440f25df6b1fd415c5f7fb860ef6c76a3c3d8e72c5bfa73b24f45bf84"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    manifest_sha256 "f46313c1142ac85cfa80f43fc6dba5bc3b2c11e291258560728c86f04247a6cf"
    sha256 cellar: :any_skip_relocation, all: "7d9c380a97d3f1fca3a468cb945038a721a1891f20b276b965d03d0f05de51b1"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
