class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.4.6+release.autotools.tar.gz"
  version "0.4.6"
  sha256 "fa8f2ff5d9b74c00b3fed5edad2aefdfb79a6cd370bf5ec9894b2121f49fb67e"

  bottle do
    cellar :any
    sha256 "f296fa5f01c9ab73cc3b3049c9765eec534a0dfe08add146181ea2fff9f7ecd8" => :mojave
    sha256 "8707e9a0a3c6bec10bbc8ce1de14ecb12f22223c132b23450ca57df30ea5ea9b" => :high_sierra
    sha256 "1720cd6b810d487716a4580175764ee2ffe01ed31381e74b376d06ee25d2ef1b" => :sierra
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  resource "mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-vorbisfile"

    system "make"
    system "make", "install"
  end

  test do
    resource("mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
