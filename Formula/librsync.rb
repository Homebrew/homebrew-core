class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.2.1.tar.gz"
  sha256 "b5ab8e2092b82b7d7bb9c1dd52e6a77083a89f8ad9b9309da611f490d0b49a71"

  bottle do
    sha256 "232b2a47795d07f9265b92a056a929e1d34ebb6419e307b6bacff429b5868114" => :catalina
    sha256 "e05a45cf32e871d343bbee800a48870c44fa0030d85850bd079bb0eb324cdc37" => :mojave
    sha256 "a769c1226480c91ea14bebae631e12aa80b91fdad7983e9f9401c793027d9691" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end
