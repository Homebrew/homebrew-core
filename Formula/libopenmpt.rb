class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.4.12+release.autotools.tar.gz"
  version "0.4.12"
  sha256 "0ccd64476e6c8a084277e7093c4034d702e7999eeffd31adc89b33685e725e60"

  bottle do
    cellar :any
    sha256 "bbd177bd2a6d5a3099872b01d683baac49670177486c24223c491561ab7e4664" => :catalina
    sha256 "a0921009b3d6a08f49e5a1a3522aebf38c6bf4e146eaa6a8c36b97eb3c67041a" => :mojave
    sha256 "ae89cc969325498d052e300372716603a4f22da3a954bb1771b65cac1119e9dc" => :high_sierra
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
