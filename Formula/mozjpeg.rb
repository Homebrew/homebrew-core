class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v3.3.1.tar.gz"
  sha256 "aebbea60ea038a84a2d1ed3de38fdbca34027e2e54ee2b7d08a97578be72599d"

  bottle do
    cellar :any
    sha256 "da5e5714bb881b7c4fba0f91b0649caff19424a63d397211506e28deff57947b" => :high_sierra
    sha256 "064155896464277965bd3abc8581ade6a6c42938045df5418af2a17cb8892b11" => :sierra
    sha256 "cd32c9a3b91acf653f34bfe82c92b44dfa7820ac15fd4c497a1e68a218cdebc0" => :el_capitan
    sha256 "ba216c159f6ef8573699a11dd423c53f9b34432000cef18a30c8e3c3e27bda2f" => :yosemite
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "nasm" => :build
  depends_on "libpng" => :optional

  def install
    system "autoreconf", "-fvi"
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
