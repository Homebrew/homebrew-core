class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.52.tar.gz"
  sha256 "e433da63af7161a6ce8b1e0c9f0b25bd59ad6d81bc4069e9277c97c1320a3ac4"
  revision 1

  bottle do
    sha256 "4deeacd897afde29f6c83c5567b0a7e840b17239ada9444bf443921b6a473077" => :catalina
    sha256 "372fe52c862a363de4fa2f28280dc5f13b9dc888150f6f63edbda7e80d9eace4" => :mojave
    sha256 "520194dad8e62f5e7c089586b6950e7c67558be7462d59a84172c59b734fa294" => :high_sierra
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
