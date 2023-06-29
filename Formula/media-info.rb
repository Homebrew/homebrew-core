class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/23.06/MediaInfo_CLI_23.06_GNU_FromSource.tar.bz2"
  sha256 "6d29ca46627681680cd52807c221111074bad0cb4ebe18c78b19c2ad24ee882d"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7806abe9c4b64fbc618f26cddced6287ba35168aa529dde45b1b452f3dc7d89d"
    sha256 cellar: :any,                 arm64_monterey: "deda8051be796e6d781144be27aec49deee877bb464c467f4873db409767d6de"
    sha256 cellar: :any,                 arm64_big_sur:  "7438ebd095b1f2b3e41441b110534d4bff1c5942e68187bf7c0b3aa41e4ead74"
    sha256 cellar: :any,                 ventura:        "0c0e753f7886c8b5d14483d2669f49a143b666e813ffb1c144971350994aa6a9"
    sha256 cellar: :any,                 monterey:       "7fc02a567e48651ceb33d94460c9f947d905967037cde6af651d90cb974c7ca4"
    sha256 cellar: :any,                 big_sur:        "ef54e34d0110234408a20a51fb32de4f11eef8aac67ea83043c3325193128dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1237598e0d261490d3376e77041d80c7f88a5577c5b274a7ddd80a1ec2cfde2c"
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
