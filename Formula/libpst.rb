class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.71.tar.gz"
  sha256 "fb9208d21a39f103011fe09ee8d1a37596f679df5495a8c58071c4c7b39e168c"

  bottle do
    cellar :any
    sha256 "23a35d1d7f679083d680723ca988801d9d215f7397fc5c87bf7f69e9982ee325" => :high_sierra
    sha256 "e869aa195bf9ad6d4d07d62cb48d9a4a52a289ecd79d1e61a44f84384d278878" => :sierra
    sha256 "85834aa1da7888a054391c7fe036d9d72f2a889adb6df3ec911193a3919a7db3" => :el_capitan
    sha256 "4b61b07a89496925c88f0f47d361465cf646f7b3caa01e470ba7eba7945442aa" => :yosemite
  end

  option "with-pst2dii", "Build pst2dii using gd"

  deprecated_option "pst2dii" => "with-pst2dii"

  depends_on "python" => :optional
  depends_on "pkg-config" => :build
  depends_on "gd" if build.with? "pst2dii"
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"
  depends_on "boost-python" if build.with? "python"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-dii" if build.with? "pst2dii"

    if build.with? "python"
      args << "--enable-python" << "--with-boost-python=mt"
    else
      args << "--disable-python"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
