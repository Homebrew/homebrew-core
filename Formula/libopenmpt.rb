class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.3+release.autotools.tar.gz"
  version "0.5.3"
  sha256 "e7282a50e17d3d4c4a6d8000d409f6234f468f8113fcb33ee4ed945d9c2f25b8"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    cellar :any
    sha256 "8cb20a0a1c82e950d9383d3b397c1ad7c92c49783a3e762b5ebe54b27c0dcca6" => :catalina
    sha256 "87b8ce1c8810945ea3cc5c80f98077802a831147a4b065cce2558325be54ec15" => :mojave
    sha256 "b5c28ae821299a51037496a041dd9cb75495c49bd5cdd14774bb8b57839f2a11" => :high_sierra
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
