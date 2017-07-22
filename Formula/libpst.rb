class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.71.tar.gz"
  sha256 "fb9208d21a39f103011fe09ee8d1a37596f679df5495a8c58071c4c7b39e168c"

  bottle do
    cellar :any
    sha256 "19b8a432c26fc588ae5d14bc289a4d988235b8a5b249b4f92ad0ac42432b360c" => :sierra
    sha256 "2a33a8240ce33640057d771f9c61e5db9d632a62d316d09ef75282491d2703be" => :el_capitan
    sha256 "bc19125e7bbb6ffa5226fead3f68cca6eaa48c61b8437ae857bb440eb3e70c21" => :yosemite
  end

  option "with-pst2dii", "Build pst2dii using gd"

  deprecated_option "pst2dii" => "with-pst2dii"

  depends_on :python => :optional
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
