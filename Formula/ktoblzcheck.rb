class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.53.tar.gz"
  sha256 "18b9118556fe83240f468f770641d2578f4ff613cdcf0a209fb73079ccb70c55"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/ktoblzcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "11c08b9ae4ce285d404ee1eeba912f8bb37b44fe1a142372d366f6233f7e111e" => :big_sur
    sha256 "b7abb3dd65cefac9c8ebe1f54482c42adc6a4dbc2c6e3f18452f4b500d5d9aa5" => :catalina
    sha256 "94c9812c2bcffef71b7e6805fa0f54b4a17cc52cb92dadb87fd804fcfab97701" => :mojave
    sha256 "39e8b0149fcd448eddace995b7dc37331716b25a5f77b2be5f7b3eb462635854" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

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
