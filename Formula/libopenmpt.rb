class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.1+release.autotools.tar.gz"
  version "0.5.1"
  sha256 "aa03a755e79e7de4fe2b7b47b9686f5c86942931c5e300b3dfa4af99b5a3eaee"

  bottle do
    cellar :any
    sha256 "8b1e3af270bbddc314fd7a081289d81f6d144de464624d241bffdea55ca85b47" => :catalina
    sha256 "f5063e9fed9060ce7f0eea90743ddbca115a80b4f97f715d28c19ef144ee5acd" => :mojave
    sha256 "127c3e53b025a84290eaacb481f6f28129fc98cf359de4afb25de27adfa27114" => :high_sierra
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
