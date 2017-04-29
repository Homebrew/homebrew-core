class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  url "http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.28.tar.gz"
  sha256 "1ff33929f042fa333aed1e8923aa628c3ee9e1eb85512686c55092d1e5a9dfa9"

  bottle do
    cellar :any
    sha256 "d62e838578eef2bd9ec76a8cc2ee48016c20b83bd4edce89b61892a640d666fa" => :sierra
    sha256 "31bdf218e00a1df4e659e098b4abb73a75f69e3a3372a9116f57a2714d27fe35" => :el_capitan
    sha256 "4b6e891dc0dde551f1ee73ea508553ebb1c84c08fbdc5ae0e874e30ab0367ffb" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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
