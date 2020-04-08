class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.3.0.tar.gz"
  sha256 "682a90ad2b38555d5427dc55ad171d4191d5955c21137e513751472e2ed322bf"

  bottle do
    sha256 "8ee8d0fe9d8d8db9fda7aca3322e4caf68a674f44859117e539e875377f69406" => :catalina
    sha256 "4cce7ef51ecbad4186fb781231a45c9618ad5fd26d2cc04953783b4906a456e8" => :mojave
    sha256 "bcc75443712ad6346dae0a31554c79451495afd089d2e9faba37bb0f46a36413" => :high_sierra
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
