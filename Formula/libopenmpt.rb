class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.4.10+release.autotools.tar.gz"
  version "0.4.10"
  sha256 "6a2804d5491eaa90e4b2d7fb5d68e436113e8c8fd164fc705547bcb23a8f258a"

  bottle do
    cellar :any
    sha256 "11940fb1b2afac44b1f7c18eb1f313a4c97abd59c81af40ee076fda1c6580b43" => :catalina
    sha256 "c8702f4b8a0a4f1385725a93edf495f269f02d665374b99b9c721fbb1f660a48" => :mojave
    sha256 "914c4183efdccd7c4af6906122398e8b8df3918dd34a6c13f96a323a1852ab21" => :high_sierra
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
