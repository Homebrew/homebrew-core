class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.3.1.tar.gz"
  sha256 "dbd7eb643665691bdf4009174461463737b19b4814b789baad62914cabfe4569"
  license "LGPL-2.1"

  bottle do
    sha256 arm64_big_sur: "f849718419f4b2bcd7411e9840a3f075ab8880794d342fc6eb3521c454d3ef8d"
    sha256 big_sur:       "718cdee2aa974cb87367e5fcf26eee51e4d77552a9033622a8c3584e09f99f0e"
    sha256 catalina:      "eb1526a88a99556f1ae98c7fa008a8c17ddbe2efe2e55de0192ccbccf9840937"
    sha256 mojave:        "27f16505bf1b37a9701d70701e708451d47743a3b4d453dcc1d4048065af05af"
    sha256 high_sierra:   "20fd33975022b7caaa12b9906b726f1b9dd9a792d9291170e72298a351650610"
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
