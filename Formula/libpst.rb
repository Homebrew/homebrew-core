class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "https://www.five-ten-sg.com/libpst/"
  url "https://www.five-ten-sg.com/libpst/packages/libpst-0.6.74.tar.gz"
  sha256 "f787dadce74a9578939ab54babb3f3f0086808cdee2370d7faac9e1fad44fd37"

  bottle do
    cellar :any
    sha256 "657dbfcf79cde274330de9a5a9b70d4dff2ca4ead724af25e9f65026e5ed2e82" => :catalina
    sha256 "6e61e40011baa8eec269d3e3c08d30f060cc318a3c2bbeaae87a27b5e21e5c23" => :mojave
    sha256 "0bd786dea8fbf1773041100b9ce5cbfc06b170a3fa18728f66420b22abe88550" => :high_sierra
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
