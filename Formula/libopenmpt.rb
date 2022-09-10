class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.5+release.autotools.tar.gz"
  version "0.6.5"
  sha256 "f22abe977cdae405f685b75150e7fb155b2c7896b4700fd54abe68840f66e9c0"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b508e3b498644c74776d40f556720fc58d1b56aeca5996f22785fa0206ba877"
    sha256 cellar: :any,                 arm64_big_sur:  "bd24ffbe87db4766bb3a223a6e92f155c07cd6d6d9727806fc3a6b8f0eb765d9"
    sha256 cellar: :any,                 monterey:       "b6be52f6d344ae8f52912b766dfcfb736726981765c653693cf56051aada704b"
    sha256 cellar: :any,                 big_sur:        "5cdc71c9aae79e5f0240b7e4ddb3838eebed53d82be1e08aabe391b1270d21d0"
    sha256 cellar: :any,                 catalina:       "414e41ca8531a6fe645a618e4bb368a227971f6cfba2ab87a0c0319620ff397c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16dcd595cac2d5111da1cf1c5d89aef015d4fcde39ed24262f0f21a223229bc0"
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
    depends_on "pulseaudio"
  end

  fails_with gcc: "5" # needs C++17

  resource "homebrew-mystique.s3m" do
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
    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
