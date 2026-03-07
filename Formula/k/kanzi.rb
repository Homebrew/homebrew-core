class Kanzi < Formula
  desc "Fast lossless data compression"
  homepage "https://github.com/flanglet/kanzi-cpp"
  url "https://github.com/flanglet/kanzi-cpp/archive/refs/tags/2.5.0.tar.gz"
  sha256 "1f0c49c79203130cf5875669243787aae0d63ed980d1825d3ac1b986062c9648"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    system "cmake", "-B", "build", *std_cmake_args
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
