class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.4.3+release.autotools.tar.gz"
  version "0.4.3"
  sha256 "d77443a279003921d6f0c4edb30d1e9dda387983f44113a6d58f623c1e6942ae"

  bottle do
    cellar :any
    sha256 "0945d13776fee096b7ff45f577110b899e26474d7236b91262be04104a925ac7" => :mojave
    sha256 "f770b94077d494f48f76f5276eaabd02782611694e9e6e7adc991386a7688248" => :high_sierra
    sha256 "24e277a45135b8309b0a095dccddd2a8e88e10718b79d3c65e9c97ef0942a7e0" => :sierra
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
