class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-fts/davix/releases/download/R_0_7_6/davix-0.7.6.tar.gz"
  sha256 "a2e7fdff29f7ba247a3bcdb08ab1db6d6ed745de2d3971b46526986caf360673"
  head "https://github.com/cern-fts/davix.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "c7733777751e64c0a1218cb957fb615301f959b83ce834467740d4e97514aa92" => :catalina
    sha256 "c7921fa562e5a856e3bf71297498c42a27bcd3f8d4f2fd6a8fda5c9945171767" => :mojave
    sha256 "6ce2b3be5a9fcdb7d06c137984aa04bbc93061b9fd4ceca91ccc2fe4928f526c" => :high_sierra
    sha256 "cdbcbf1856a6c668125c7109d021352103404c018ef06537ef06d348dbe55985" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
