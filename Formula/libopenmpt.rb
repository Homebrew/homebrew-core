class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.4+release.autotools.tar.gz"
  version "0.5.4"
  sha256 "f34d06b9daa7bca111625369e5bbc2e7c0e0e04737a439b0e6320811babcef40"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    cellar :any
    sha256 "84535e4e962bc839dff23e7f647f1104c8a8872611b330a379dcb5f726a3e28d" => :big_sur
    sha256 "c6763eacaed55c8185b5baa3c40e1dad8319248d188c7281d170c0e9dcffde55" => :arm64_big_sur
    sha256 "73679bb33944dc344954b97481a10be46e8d2606f20f29ac94ee42368b346a26" => :catalina
    sha256 "958b406f594a0693e13e043c48b3b200d0bfe61c67b339b7ec245be3dcd2377e" => :mojave
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
