class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.97/MediaInfo_CLI_0.7.97_GNU_FromSource.tar.bz2"
  version "0.7.97"
  sha256 "ea1bea0ea23030128df2ca72aa94680662f37631dd087dc961eb076e73ef8125"

  bottle do
    cellar :any
    sha256 "48a18e63881d6428e41042dd6d26019f455d2b62b44879c2fa9d5edd34f1e845" => :sierra
    sha256 "895d744a5399925ae22ed0e0b8cf7ed47a3bb70de4f4f90aa7a04ba3c0661bf3" => :el_capitan
    sha256 "34bcf5d0e5717e6a450580014ad231a403a1c06e20e6891d3f5adc87f5777c91" => :yosemite
  end

  depends_on "pkg-config" => :build

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
