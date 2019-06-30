class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.4.5+release.autotools.tar.gz"
  version "0.4.5"
  sha256 "0b4cc0cc8fbbdabc6263a900ff3560dae7be43be011b6f2bc9913f7a0ed3a521"

  bottle do
    cellar :any
    sha256 "350b5a1325a663e4e474e52f228facaf36e6b9d4741f90805a4a14f30579dd21" => :mojave
    sha256 "6ae059b6571dd64edb2266c3d8710741a5361afdf2579d15726d31d4ce597035" => :high_sierra
    sha256 "2a378d7eaa4cd075a7585d9b1a300bd0ea3fa78de1e1674dab973d26cae2a4a0" => :sierra
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
