class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  # Change back to stable when upstream releases > 1.0.28
  # Fixes several security vulnerabilities
  url "http://www.mega-nerd.com/libsndfile/files/1.0.29pre2/libsndfile-1.0.29pre2.tar.bz2"
  sha256 "ffe2d6bff622bc66e6f96059ada79cfcdc43b3e8bc9cc4f45dbc567dccbfae75"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "6399523ef99f5c9ea4adcb8ce4af9406c32673deab4beba7114b32162a9b3c54" => :catalina
    sha256 "e7cb1a29d931a1637ec84a5ba6b71d37801dc0bb4eab38051df19755cb048667" => :mojave
    sha256 "d06bf0bf936cde67857ac3d3599944d2050ea8dc6237bad8b4c27ef86ac2eb3c" => :high_sierra
    sha256 "4e4bde6464cfbefcf7f2a9001af0ea34c6273b466ffa71ac953b2bb41eb619ec" => :sierra
    sha256 "49d17fa55815680936b529b7bbb8e5cf180c98722c7f8b45d763bfe2d1f0a5de" => :el_capitan
    sha256 "9df59790751d64c7f61682233a733030de9e6406682f3a15e30e708103930038" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/sndfile-info #{test_fixtures("test.wav")}")
    assert_match "Duration    : 00:00:00.064", output
  end
end
