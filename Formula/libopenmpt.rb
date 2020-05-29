class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.0+release.autotools.tar.gz"
  version "0.5.0"
  sha256 "43cba54a3f7220c3cc5baae1e2c19a5af7196bfdb95ff4d0c4979d9fbc6c837e"

  bottle do
    cellar :any
    sha256 "0f7edae0c0cd51711e0e3713b4d88d7087d7b27b2b10a0c980c3c1d55bde94d0" => :catalina
    sha256 "e78fb3de4e4f3b0828fad3f455df36193875f611882d2617e67a730ccc3453de" => :mojave
    sha256 "50e679024f8f4be382d8b5c381626e7b6a7c67e8b37530cc868131e2e8968961" => :high_sierra
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
