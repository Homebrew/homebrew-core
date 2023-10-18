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
    sha256 cellar: :any,                 arm64_sonoma:   "c90d1afff9bc40be92c04d7808060f029e6c182816d0b901c58ae86ffffd8348"
    sha256 cellar: :any,                 arm64_ventura:  "365cb23ac705299f29269266acdca8a587c664b83d6b15e4806c397048bd3138"
    sha256 cellar: :any,                 arm64_monterey: "d527587cc93960ce5ffe5b7b5e6d02dfc95f9ee7f7369ba03558aca2fa3bb2d4"
    sha256 cellar: :any,                 sonoma:         "48e77f415f1611e06d665461872cd6a6b00ff98a1e5f88305694d56de9209842"
    sha256 cellar: :any,                 ventura:        "edefcf3e1ab720312cc4adce50ab5a418e96b1f64c0c471f1ea0028f4a666c58"
    sha256 cellar: :any,                 monterey:       "5bf8f83139118fef51daf91100bea4444e19f0491bc6df94e07786824ee52fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c23a7ca4929508601441c1085294cf5441c3104df9b430f122f2569cc75b3c"
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
