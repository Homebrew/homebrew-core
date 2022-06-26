class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/22.06/MediaInfo_CLI_22.06_GNU_FromSource.tar.bz2"
  sha256 "e96633cfced36e7810fc5cd0f15a83362be1f4670e0b38971d8172003dd068d3"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8b24d5ae8ea40e7a23bbb50a37c8b9dbee55cf4294d613fb693a5d9c4efa1371"
    sha256 cellar: :any,                 arm64_big_sur:  "cc1c9fdcce0308d85c9d1475edaebbf9e9c90e06594b49de04d7fbf638294d8c"
    sha256 cellar: :any,                 monterey:       "ff0e87a34917f7adb55f44783322fce7724c110206efc46df736d773c5542fe7"
    sha256 cellar: :any,                 big_sur:        "840a9f8518f369f2269242eb241f665588c2245e793c44791ddb0da2cfd7cfc6"
    sha256 cellar: :any,                 catalina:       "f812ef569a1256b049c7e8c6b7c45223d686527af1d2b8073dc7dc4397f0a3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e0635c6e62553b450fc3ddcdc3d4eff9e8bd6a751406618494a1bcab757a77"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

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
