class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.53.tar.gz"
  sha256 "18b9118556fe83240f468f770641d2578f4ff613cdcf0a209fb73079ccb70c55"

  bottle do
    sha256 "93495421d21c635d04637865d68c922d70ed0112b01929d113d21cd533afabc1" => :catalina
    sha256 "447d1889a2350c704d8c4d276c8122f8ecd24b906f5b4944e39bdbb77bf39962" => :mojave
    sha256 "242eca7d985cf7d70b78a2838d96a7b91b1e67b68ca7376919296bc253a99540" => :high_sierra
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
