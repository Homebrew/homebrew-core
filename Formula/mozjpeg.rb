class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/releases/download/v3.2/mozjpeg-3.2-release-source.tar.gz"
  sha256 "8aecc1ecad447a73ae01b9a546e99142345e5a92838d84af425f2b19202e7b73"

  bottle do
    cellar :any
    sha256 "064155896464277965bd3abc8581ade6a6c42938045df5418af2a17cb8892b11" => :sierra
    sha256 "cd32c9a3b91acf653f34bfe82c92b44dfa7820ac15fd4c497a1e68a218cdebc0" => :el_capitan
    sha256 "ba216c159f6ef8573699a11dd423c53f9b34432000cef18a30c8e3c3e27bda2f" => :yosemite
  end

  head do
    url "https://github.com/mozilla/mozjpeg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg"

  depends_on "pkg-config" => :build
  depends_on "nasm" => :build
  depends_on "libpng" => :optional

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-jpeg8"
    system "make", "install"
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose", "-optimize",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
  end
end
