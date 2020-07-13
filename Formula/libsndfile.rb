class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  # Change back to stable when upstream releases > 1.0.28
  # Fixes several security vulnerabilities
  url "http://www.mega-nerd.com/libsndfile/files/1.0.29pre2/libsndfile-1.0.29pre2.tar.bz2"
  sha256 "ffe2d6bff622bc66e6f96059ada79cfcdc43b3e8bc9cc4f45dbc567dccbfae75"
  license "LGPL-2.1"
  revision 1

  bottle do
    cellar :any
    sha256 "8e8f467cb9efe8ae6a5c174444c4829d4625c2314fb32a7edb4e53947d6fb035" => :catalina
    sha256 "87699449cdb6d6d1ca03598fccbcfdbfb1db3da6ff83af6de353a0badb01b889" => :mojave
    sha256 "ac676c5d492f2daaefdbedb046c256a2929f4287db2e3eed01d0af394e769a41" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"

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
