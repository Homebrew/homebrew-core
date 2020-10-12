class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  url "https://github.com/erikd/libsndfile/releases/download/v1.0.30/libsndfile-1.0.30.tar.bz2"
  sha256 "9df273302c4fa160567f412e10cc4f76666b66281e7ba48370fb544e87e4611a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libsndfile[._-]v?([\d.]+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "bf93a0083eecbcadc7eb391b9f429e0f55c4f571b5f4d9104cfaf60f8e5932dc" => :catalina
    sha256 "ef1bd6eb6f6d33e22a05116b0893d85422e3ad7fced4252eace97232e523075d" => :mojave
    sha256 "9d7d184ccf41eff27b8425a8fd50d60fa8a383338efcd0dcf7121f0ce7e3545c" => :high_sierra
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
