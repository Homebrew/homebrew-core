class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/23.10/MediaInfo_CLI_23.10_GNU_FromSource.tar.bz2"
  sha256 "604d26c28da08e8dc1aba50d651aa796ccf8ddb984de3385cf3c4cf6aef1d4ce"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b158cae291bbc2266219ad1bbea13790d946fe4adf014e97c848814c5b76d13b"
    sha256 cellar: :any,                 arm64_ventura:  "a5d8ca13a73b6bbdad455957bdca1c89332675bd6f7a79a8a7c499b58ac47a77"
    sha256 cellar: :any,                 arm64_monterey: "54f216d9d5c17db7667dde8bf7c57bb93a7c74c9dc77e05acad7c8363870d30c"
    sha256 cellar: :any,                 arm64_big_sur:  "84b2c77f1154f29f43d6655f87d2f583d026e5301c157ca76c8a62f890b3d627"
    sha256 cellar: :any,                 sonoma:         "c9742e93a5e1419d019e6ca1f7638a05d5a893eabfa685a5d9a818f137de8b24"
    sha256 cellar: :any,                 ventura:        "eceb4ce5d69dc94759305fac9d74e42935210844f3e71ba9aaad0d3b76721854"
    sha256 cellar: :any,                 monterey:       "67e69a55b80d63a1a07cb6a7ef1a589ca9c7b5f9bc3c0592cd2fea62ef95b846"
    sha256 cellar: :any,                 big_sur:        "3889ceb7fe47c3d8ff0dc39eeecb0d99f80e7aba0aee028c2275e69d93af9612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be26673ed4fc410bbbdf76eccabe5f2c9f87230175ec15dac0bd17da5590e5bc"
  end

  depends_on "pkg-config" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  uses_from_macos "zlib"

  def install
    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end
