class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  # Change back to stable when upstream releases > 1.0.28
  # Fixes several security vulnerabilities
  url "http://www.mega-nerd.com/libsndfile/files/1.0.29pre2/libsndfile-1.0.29pre2.tar.bz2"
  sha256 "ffe2d6bff622bc66e6f96059ada79cfcdc43b3e8bc9cc4f45dbc567dccbfae75"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libsndfile[._-]v?([\d.]+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "8e192a4b76ad637395dfce818e2eec62e3a90722b33759fefcd4af389498bb9c" => :catalina
    sha256 "1784457959d0c8ca513223f12e6f884f0dafe74ea0e9511e8c7d1b2557cfbb91" => :mojave
    sha256 "3ae061cb03f627870e9fe98cd65f538547f109f472d20d235103ab4625d22b94" => :high_sierra
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
