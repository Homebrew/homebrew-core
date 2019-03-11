class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "https://www.five-ten-sg.com/libpst/"
  url "https://www.five-ten-sg.com/libpst/packages/libpst-0.6.72.tar.gz"
  sha256 "8a19d891eb077091c507d98ed8e2d24b7f48b3e82743bcce2b00a12040f5d507"
  revision 2

  bottle do
    cellar :any
    sha256 "382d2a508b95f2b391141c778ef6a9629efa85bf4bed34d843b550b3b2729db0" => :mojave
    sha256 "3d8f0a101e022d7061e7765c7a07033e84d4685648bd3256a832db0937fe7333" => :high_sierra
    sha256 "8b65a4b37e63351f5991a8a6582aaaf93d26c81b820096da06a98da2b7a43394" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-python
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
