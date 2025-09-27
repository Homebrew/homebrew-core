class Kanzi < Formula
  desc "Fast lossless data compression"
  homepage "https://github.com/flanglet/kanzi-cpp"
  url "https://github.com/flanglet/kanzi-cpp/archive/refs/tags/2.4.0.tar.gz"
  sha256 "0fdf5979dd3712d8e143a084fa46cf2113058213c5bc02b834371fd6764fc19d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6276e6e8448764518f783b0bd28761a47c5ae343e7cc457cb409e844bf24b3d4"
  end

  def install
    system "make", "install"
  end

  def uninstall
    system "make", "uninstall"
  end

  test do
    srcpath = testpath + "test_kanzi.txt"
    dstpath = testpath + "test_kanzi.txt.knz"

    srcpath.write "TEST CONTENT"

    system bin/"kanzi", "-f -c -i", srcpath
    system bin/"kanzi", "-f -d -i", dstpath

    assert_equal "TEST CONTENT", srcpath.read
  end
end
