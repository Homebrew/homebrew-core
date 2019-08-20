class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.1.0.tar.gz"
  sha256 "f701d2bab3d7471dfea60d29e9251f8bb7567222957f7195af55142cb207c653"

  bottle do
    sha256 "f7ae326eb738ba4ae1616722e532fd380c377fb6ce09850329087917d6c9bc12" => :mojave
    sha256 "493b63f3dbda84ef940589a68dfd841ff26d704c472c02e717476de142ab4f1f" => :high_sierra
    sha256 "70369dce43e726a4b9561087cf5b2e8617c095dd240d9d4136318bbb9dab8802" => :sierra
    sha256 "490c2360a7e502ef4cbe1899c93618e72d298d61f5cc2496f8d8c59725fb15d9" => :el_capitan
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
