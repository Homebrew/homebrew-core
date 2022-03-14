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
    sha256 cellar: :any,                 arm64_monterey: "005c8a54e9dfda789cd2c763e1e843efa2fb5e7ea177bacb3f2c984821ea242b"
    sha256 cellar: :any,                 arm64_big_sur:  "712d4ff4a0ad17dd56fb87697915893d543cccad7dc79aa0485736ed48767091"
    sha256 cellar: :any,                 monterey:       "4254684e80f25e99b633314cf03b3f0675999e8de8e288e1072615b2e606c195"
    sha256 cellar: :any,                 big_sur:        "d4b99f090eaae5668c6fa6178b0253c6ea991f8b9057eedbe5392970658e3411"
    sha256 cellar: :any,                 catalina:       "ed44a56af7d031907a73b207530ffaddc9d8e15e500c2924094f40443fd513dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c709ca20ec17ed6f9b16220813a8b7adda3694b245f3ee9986a7e430db5a929f"
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
