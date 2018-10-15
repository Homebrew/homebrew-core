class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.3.12+release.autotools.tar.gz"
  sha256 "7134db999d33b96dc2db13dbaf29b7beeb4c58f62e57fd3caf36bb8428aa4b42"

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "portaudio"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-mpg123",
                          "--without-vorbisfile"

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/openmpt123", "--version"
  end
end
