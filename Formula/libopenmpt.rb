class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.1+release.autotools.tar.gz"
  version "0.5.1"
  sha256 "aa03a755e79e7de4fe2b7b47b9686f5c86942931c5e300b3dfa4af99b5a3eaee"

  bottle do
    cellar :any
    sha256 "6a8c50783c52bfd802c9af881350444b023dce7732d721f8817f73b733cff537" => :catalina
    sha256 "9a9a52b12e1030fcb91030a328d4316e0b18cc29b9226e2335b5108c4e170a39" => :mojave
    sha256 "3ae6650e73c4b0bd15905da55281593f581110fbd55c8296c590d8ee7b55d789" => :high_sierra
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
