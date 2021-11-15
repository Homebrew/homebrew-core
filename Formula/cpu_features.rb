class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.6.0.tar.gz"
  sha256 "95a1cf6f24948031df114798a97eea2a71143bd38a4d07d9a758dda3924c1932"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "e4cc8363ff01721edffa3c1c48fdefc2f50973468f130feb2c8a8635da723b7c"
    sha256 cellar: :any_skip_relocation, big_sur:      "f6bebf333094fed54f5a96c9dc96280f7a2ca6c7b075cbed9c77a9214fafd8c4"
    sha256 cellar: :any_skip_relocation, catalina:     "ba67bb2d2166f43b17aba3fb4f8306b577e17779e8a8facea32a16451c7b369d"
    sha256 cellar: :any_skip_relocation, mojave:       "9f7d3b134c25934208808a47a8c8ecde61d8a7c3d429246ce807d9183930bd66"
    sha256 cellar: :any_skip_relocation, high_sierra:  "057d70560cecfd8863543a562ddb0ec64147ac3ce6292adedf0bc28c74a92349"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eba6a3614e0c50480292250b36dfce454e572696b73eb6a6be476fb637688101"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output(bin/"list_cpu_features")
    assert_match(/^arch\s*:/, output)
    assert_match(/^brand\s*:/, output)
    assert_match(/^family\s*:/, output)
    assert_match(/^model\s*:/, output)
    assert_match(/^stepping\s*:/, output)
    assert_match(/^uarch\s*:/, output)
    assert_match(/^flags\s*:/, output)
  end
end
