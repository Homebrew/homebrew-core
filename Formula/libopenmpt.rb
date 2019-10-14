class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.4.6+release.autotools.tar.gz"
  version "0.4.6"
  sha256 "fa8f2ff5d9b74c00b3fed5edad2aefdfb79a6cd370bf5ec9894b2121f49fb67e"

  bottle do
    cellar :any
    sha256 "d939c3e1b4d2a259f2922a15a781408950a71bccbf102533896bd14b2b9bf131" => :catalina
    sha256 "1d879d62f9735a878b7ca9dc1c58c5c0c0689a4ba1382852141117c44497fa9c" => :mojave
    sha256 "03641eeb64206a5c2dd4cd83f329257910905745206c03f631178999c4adba5d" => :high_sierra
    sha256 "d0dcb2682450017ae2c58968e4cad7cb778f627f7cb93eaab12792135eb17def" => :sierra
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
