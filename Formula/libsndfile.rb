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
    rebuild 1
    sha256 "5f5f4ad1f22b2893b115fdf972c1f8f30a4919719f12fe0f3d186f879eae3051" => :catalina
    sha256 "5e0f78600b00ca0ebdbafe83e0a0a0a4833810233d714300acac13babb7553bf" => :mojave
    sha256 "83fe3a19e7c679b07ed791dafeb2e942540092ae714f7c73ae7168ba2115179b" => :high_sierra
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
