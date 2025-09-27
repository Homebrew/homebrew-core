class Kanzi < Formula
  desc "Fast lossless data compression"
  homepage "https://github.com/flanglet/kanzi-cpp"
  url "https://github.com/flanglet/kanzi-cpp/archive/refs/tags/2.4.0.tar.gz"
  sha256 "0fdf5979dd3712d8e143a084fa46cf2113058213c5bc02b834371fd6764fc19d"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    srcpath = testpath/"test_kanzi.txt"
    dstpath = testpath/"test_kanzi.txt.knz"

    srcpath.write "TEST CONTENT"

    system bin/"kanzi", "-f -c -i", srcpath
    system bin/"kanzi", "-f -d -i", dstpath

    assert_equal "TEST CONTENT", srcpath.read
  end
end
