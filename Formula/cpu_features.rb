class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.4.1.tar.gz"
  sha256 "b7b6b27f759410f73f15f935ae646f30c9c6742731dc354416399677bd418156"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output(bin/"list_cpu_features")
    assert_match /^arch\s*:/, output
    assert_match /^brand\s*:/, output
    assert_match /^family\s*:/, output
    assert_match /^model\s*:/, output
    assert_match /^stepping\s*:/, output
    assert_match /^uarch\s*:/, output
    assert_match /^flags\s*:/, output
  end
end
