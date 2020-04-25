class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.53.tar.gz"
  sha256 "18b9118556fe83240f468f770641d2578f4ff613cdcf0a209fb73079ccb70c55"

  bottle do
    sha256 "fe801d5a372699c9a84f63476eb332004cd09461118d019a919c7f3fb1884fe9" => :catalina
    sha256 "75ffa5ac1e50aee72355cfb41419d88354954f4fd8e9414261037ef7e00a3474" => :mojave
    sha256 "5c6397edbca81abcd841366fdcb1f8df042376c6f8e996005f2c71bd6ba2b0f0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match /Ok/, shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789")
    assert_match /unknown/, shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
  end
end
