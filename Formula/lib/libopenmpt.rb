class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.9+release.autotools.tar.gz"
  version "0.7.9"
  sha256 "0386e918d75d797e79d5b14edd0847165d8b359e9811ef57652c0a356a2dfcf4"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a9add55f30ad9f27363e1d9e74a2624e8cdcd54edaaf3566e831b10503d0a66"
    sha256 cellar: :any,                 arm64_ventura:  "14d67acb17b67e2b27ac95166e159c41b9f1b88e015f80539dbeddd8edeae711"
    sha256 cellar: :any,                 arm64_monterey: "9e8b831830d2451e2f82a3848eb11853c3fc6f8a216634017ad866f3284f1ec2"
    sha256 cellar: :any,                 sonoma:         "90ae8aad06c3778264a4584a2ece2b3db2260039d042f4efab231de4815f83ef"
    sha256 cellar: :any,                 ventura:        "e2a9ce934105d0114dfcc9f5761ff360650054e25c7a4a9b9be9159a33c7eeb9"
    sha256 cellar: :any,                 monterey:       "bcf95eba8c15f1f591b698341df7cbacbd9afb9595fe837ce9ebe32fe1359309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab14c503704933ae4d535acd737fa6bdc4d3eac5bb706583cbb4baf509491cb9"
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
