class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "https://www.five-ten-sg.com/libpst/"
  url "https://www.five-ten-sg.com/libpst/packages/libpst-0.6.72.tar.gz"
  sha256 "8a19d891eb077091c507d98ed8e2d24b7f48b3e82743bcce2b00a12040f5d507"
  revision 3

  bottle do
    cellar :any
    sha256 "713575b82c8c6121fb24b6e81f3db9c97269ce36b7437bf627005aca52adbd0c" => :mojave
    sha256 "53d20866aae36d6c27f70b87ca5ebdc95fce3812c0f7867ace75195851cb9255" => :high_sierra
    sha256 "ba6f9f3cc335802c9dd31f7098c71c06adcc014ac4de0f821cd823956a6839fc" => :sierra
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
