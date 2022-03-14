class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.2+release.autotools.tar.gz"
  version "0.6.2"
  sha256 "50c0d62ff2d9afefa36cce9f29042cb1fb8d4f0b386b81a0fc7734f35e21e6b6"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ae693ffcf795c795753afa50d8306ed888b90c6569c1fcb3bde280912d26c3d"
    sha256 cellar: :any,                 arm64_big_sur:  "37a157780ba7ef0507a3da11bd350796d3e26a16ac7cc9e128c07d76e0ad163b"
    sha256 cellar: :any,                 monterey:       "e1acfb7fc4921077f5700c1e51be6f7ce2a15cd8cfcb9cb13be9595969a337b5"
    sha256 cellar: :any,                 big_sur:        "9207908fabb5d34783165c9d46bcf792940bf6c7fdb90991c7dcf51705fca428"
    sha256 cellar: :any,                 catalina:       "88a75a6df13605b5b3398aebe2489c38bf5b347c50e4cdb630d8c53096032677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18c7ae4c72b1606180b5eca6780df3603408d5a3908bf6ca25f74dda7a1930e3"
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
    depends_on "gcc"
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
