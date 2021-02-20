class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.5+release.autotools.tar.gz"
  version "0.5.5"
  sha256 "f1e01483ebf1a680d9ec030c9af20f5f2a5ac0f1e0642c18bd5593cfaa9ceb6b"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b41a555aca663ae452190910fd2c5fbee37588b864ad64ecea0471dbefd60690"
    sha256 cellar: :any, big_sur:       "9cff46a437ec6052a185659845f023d58e6ed0746b8795e302e2c19ede3ef495"
    sha256 cellar: :any, catalina:      "7aa35598ce904e38740c90f9c61b2c51b03868229502224e7d36cc680ea85851"
    sha256 cellar: :any, mojave:        "faf5143021862bc64b2be69a40407fa30e0a609fc4851ae3fcea056e9a72cddd"
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
