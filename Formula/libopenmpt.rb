class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.14+release.autotools.tar.gz"
  version "0.5.14"
  sha256 "a979c1a763dcb420d40004eaeadd5532153b63493e6bfb71362204ee8a75abdc"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "045be27a84133e369746336645852290d50469116fadb1a1d51c9ef26c06f565"
    sha256 cellar: :any,                 arm64_big_sur:  "cfd024497f2b07f58c64509eb62340da4dc18e0daff8babc16cc64b6106ca4db"
    sha256 cellar: :any,                 monterey:       "b02d8b4fb57ed35a9bb5aea15980a625d925c3e768d1bb9ad00792c7b1344da6"
    sha256 cellar: :any,                 big_sur:        "7c153427e2faaa18fef196a869a13567395936419ddf904e959c6175142828fa"
    sha256 cellar: :any,                 catalina:       "cf2ce3d2302c2eabf1c910453beb20fcc9b058bec2a6b7b748aabefbfc219200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbbfcf34a10e5a71726b324e3b8e35f2bfb9281a4358739e9c3c2293b12aaef1"
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
