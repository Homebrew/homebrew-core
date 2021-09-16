class FeelingBlueCpp < Formula
  desc "C++ library for BluetoothLE usage on MacOS or (soon) Windows"
  homepage "https://github.com/seanngpack/feeling-blue-cpp/"
  url "https://github.com/seanngpack/feeling-blue-cpp/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "65fa7d3933078940820851e9bf3798d6ffa230815a8abf448de723d077790a61"
  license "MIT"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "."
    system "make", "install"
  end

  test do
    system "brew", "test", "feeling-blue-cpp"
  end
end
