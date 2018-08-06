class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.72.tar.gz"
  sha256 "8a19d891eb077091c507d98ed8e2d24b7f48b3e82743bcce2b00a12040f5d507"

  bottle do
    cellar :any
    sha256 "f07260d9a5ef17c294acc30f4405d90467110fda3e824b62cc2e2a0b5cb557da" => :high_sierra
    sha256 "bc247e859e53a24a53b99f4e088341dac9c197b96b2c58bd0953baab39b8c4f8" => :sierra
    sha256 "154c2402a1949c8bcd7b784181b9f1d47705b035ea996506f6d142c3c92e2423" => :el_capitan
  end

  option "with-pst2dii", "Build pst2dii using gd"

  deprecated_option "pst2dii" => "with-pst2dii"
  deprecated_option "with-python" => "with-python@2"

  depends_on "python@2" => :optional
  depends_on "pkg-config" => :build
  depends_on "gd" if build.with? "pst2dii"
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"
  depends_on "boost-python" if build.with? "python@2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-dii" if build.with? "pst2dii"

    if build.with? "python@2"
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
