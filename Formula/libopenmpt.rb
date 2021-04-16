class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.7+release.autotools.tar.gz"
  version "0.5.7"
  sha256 "c86026c47e208f1849676d1b6c5c9a068247154f38d368628c05c1f354d72c77"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4a783b8824824b39afb21b0fc445d667d25f983997a4fcac0f12893160156adc"
    sha256 cellar: :any, big_sur:       "8ff96c1665940b4d108e12b0311903fac3726ac4220ea1a9176f599d530827ff"
    sha256 cellar: :any, catalina:      "3f3e2ad6158a5142e7f8df8b9dd3953ac86aa071b2823779dfe294b464e52f7b"
    sha256 cellar: :any, mojave:        "73e6c93055092c895be8283ff6d7e73020cd2665cdd2c70f43cce1a31d8cccfa"
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
    depends_on "pulseaudio"
  end

  fails_with gcc: "5"

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
