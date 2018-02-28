class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.0.2.tar.gz"
  sha256 "e67b9520ee84f7239be6e948795803bd95495091cc00bf6d0e8c6976032a4af1"

  bottle do
    sha256 "a662f98afc2f802b9244762768d2a1b1cf2c52af76cfbdbf9e85deb20caafbb0" => :high_sierra
    sha256 "c8212dd0a99a201846b8890babe11f1bb7e138d71f4089ded592ff749c4d3262" => :sierra
    sha256 "813022e8b5ef996951c8b62e2a1cc7fca56845380b261d0b33a3638c7ceee710" => :el_capitan
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
