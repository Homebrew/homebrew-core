class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.6.0.tar.gz"
  sha256 "95a1cf6f24948031df114798a97eea2a71143bd38a4d07d9a758dda3924c1932"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d59ba9266e5071e5539fa644c3c3480f5fc4b1b1a2d535d8e82301c6de9a9e87" => :catalina
    sha256 "9a8b3073f6fee8c19d073bd828aa8e7289f6360bc077551a1401ca92a79ebb39" => :mojave
    sha256 "839ea1c38972d31f18e5a372972c6977398ffc6ab9872c0ed347a33f5a3e9c9c" => :high_sierra
  end

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
