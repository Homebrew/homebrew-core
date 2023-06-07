class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/23.04/MediaInfo_CLI_23.04_GNU_FromSource.tar.bz2"
  sha256 "bc7da8717ff74d89d1d69d886af812f5c47b1e502c1a4e05360e41c47450ff30"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "309641906e49ed27588c8eb2d4492f7797c10d79cb220f920c9ae4acefc4f587"
    sha256 cellar: :any,                 arm64_monterey: "1ccaa9936e22a61ad6f6cf7e0e9de7fa0476df71c0e067bb1da5b690aca8b55b"
    sha256 cellar: :any,                 arm64_big_sur:  "0c517e3aeab7c53bfd774b6707f00ba6ed766cf9763eade1d16b685f68371303"
    sha256 cellar: :any,                 ventura:        "784fbdd735982809214c040d10ad96549f2b7e02161a1477fc623b8a3e7c0de5"
    sha256 cellar: :any,                 monterey:       "cc397b05a22255696810fd23017fcd4ed8905955125966635712b672e22a4c31"
    sha256 cellar: :any,                 big_sur:        "d9a26fb40a72b4bbad8fc909a6a941d95227bb47950dd14ed697c66b7e005f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "978aa70db065d20da7e6797ddae6ad440b60ffa42c76122d182a4a5dc9140469"
  end

  depends_on "pkg-config" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  uses_from_macos "zlib"

  def install
    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end
