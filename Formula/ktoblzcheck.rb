class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.53.tar.gz"
  sha256 "18b9118556fe83240f468f770641d2578f4ff613cdcf0a209fb73079ccb70c55"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/ktoblzcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "d1e75023d21fbaa68a173f878474b43a24fd184664b96295641262aebef5a6bb"
    sha256 arm64_big_sur:  "95ab5216faa25bf03e89defdde3df6c417334c684c917ec07c5f8ff8c736a114"
    sha256 monterey:       "00598c7d9ff6b53ac757ab6ccc7467d8d0bf7e0b71394c439bfae4be00573aef"
    sha256 big_sur:        "5f8054e0ed931d250012966ef8da4fe5b0ca5719f2b7588ea8b5aa80712e00a9"
    sha256 catalina:       "464bc30654e445495ad0e4bd35d7bec38c16cbe4e4ea16432a8965836a2691bd"
    sha256 x86_64_linux:   "64522473dfd9dd4272ce4cd706ebef68136f130123bacc8fd57f6c28339f2a90"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

  def install
    system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{opt_lib}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Ok", shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789")
    assert_match "unknown", shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
  end
end
